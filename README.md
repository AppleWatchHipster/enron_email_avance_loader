# enron email avance loader
#### Simple Ruby load script to take enron emails from MySQL to AvanceDB or CouchDB


## Credits

 Uses data set prepared by Arne Shulz
 Available here: http://www.ahschulz.de/enron-email-data/

##
gems:

gem "couchdb"
gem "mysql2"
gem "activerecord"
gem "activerecord-mysql-adapter"


## Pre-requisites

You will need to download Arnes Mysql5 zip file
You will need ruby and rubygems installed..
You will need mysql 5.5 and either avancedb or couchdb (recent) installed

## Mysql setup

Login to mysql and create a new database - something like:

mysql -u 'root' -p

mysql> create database enron default character set utf8;

mysql> grant all on enron.* to 'enron'@'localhost' identified by 'enron'

mysql> use enron;

mysql> source 'path to arnes data dump'

Assuming this has worked you should have some tables like message and employeelist in the enron db.  Try:

mysql> show tables;

to make sure..

# Installation

You should be able to bundle install

# Edit

Change the server details for both couch and mysql

# Go

$ ruby load_enron.rb

