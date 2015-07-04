# This file should contain all the record creation needed to seed the 
# database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside 
# the db with db:setup).

User.create(first_name:  "Example",
			last_name: "User",
			gender: "n/a",
            email: "example@railstutorial.org",
            password:              "foobar",
            password_confirmation: "foobar",
            country_of_residency: "United States")

99.times do |n|
  f_name  = Faker::Name.first_name
  l_name  = Faker::Name.last_name
  email = "example-#{n+1}@fakeemail.org"
  password = "password"
  User.create(first_name:  f_name,
  			  last_name:  l_name,
  			  gender: "n/a",
              email: email,
              password:              password,
              password_confirmation: password,
              country_of_residency: "United States")
end