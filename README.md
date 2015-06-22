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
	property :fname, type: String
	property :lname, type: String
	property :email, type: String
	property :dob, type: Date
	property :gender, type: String
	property :password_digest, type: String
------------------------------------------------
Suggested 'Message' properties:
content:string
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

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
