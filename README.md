== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation
------------------------------------------------
'User' model
	property :first_name, type: String
	property :last_name, type: String
	property :email, type: String
	property :date_of_birth, type: Date
	property :gender, type: String
	property :password_hash, type: String
	property :password_salt, type: String
------------------------------------------------
Suggested 'Message' properties:
content:string / text?
sent_on:date
(directed relationship between Users)
------------------------------------------------
Suggested 'Location' model properties:
country:string
place:string
------------------------------------------------
Suggested 'Hobby' model properties:
name:string
------------------------------------------------

* Database initialization

In order to create 100 test Users in the db, run:
$ rake db:seed

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
