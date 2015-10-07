#
# Quick and dirty script to push a bunch of email docs into couch or avance
# S. Stearn, 2015

# Uses data set prepared by Arne Shulz
# Available here: http://www.ahschulz.de/enron-email-data/
#
# This needs to be loaded into a database named below
# And a user with suitable access also configured below
#

require 'rubygems'
require 'couchdb'
require 'active_record'

#
# Modify appropriately
#

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "localhost",
  :username => "enron",
  :password => "enron",
  :database => "enron"
)

class Employee <ActiveRecord::Base
	self.table_name = "employeelist"
	self.primary_key = "eid"
  has_many :messages, primary_key: "Email_id", foreign_key: "sender"
end

class Message  < ActiveRecord::Base
	self.table_name = "message"
	self.primary_key = "mid"
	belongs_to :employee, primary_key: "Email_id", foreign_key: "sender"
	has_many :recipient, primary_key: "mid", foreign_key: "mid"
	has_many :reference, primary_key: "mid", foreign_key: "mid"
end

class Recipient < ActiveRecord::Base
	self.table_name = "recipientinfo"
	self.primary_key = "rid"
	belongs_to :message, primary_key: "mid", foreign_key: "mid"
end

class Reference < ActiveRecord::Base
	self.table_name = "referenceinfo"
	self.primary_key = "rfid"
	belongs_to :message, primary_key: "mid", foreign_key: "mid"
end

# Using localhost
server = CouchDB::Server.new "couchdb.ripcordsoftware.com", 80
database = CouchDB::Database.new server, "enron"
database.delete_if_exists!
database.create_if_missing!

messagelist = Message.all.includes(:employee, :recipient)

count = 1
messagelist.each { |message|

	doc = CouchDB::Document.new database, 
	  "_id" => count.to_s,
		"Email" => message,
		"Sender" => message.employee,
		"Recipients" => message.recipient,
		"ReferenceInfo" => message.reference
	doc.save

	count += 1
}
