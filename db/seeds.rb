# This file should contain all the record creation needed to seed the 
# database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside 
# the db with db:setup).

User.create(first_name: "Ilona",
			      last_name: "Michalowska",
			      gender: "female",
            email: "ilona.michalowska@gmail.com",
            password:              "test",
            password_confirmation: "test",
            admin: true)

User.create(first_name: "Irina",
            last_name: "Kalashnikova",
            gender: "female",
            email: "ik@gmail.com",
            password:              "test",
            password_confirmation: "test",
            admin: true)
=begin
=======
            admin: true
            activated: true,
            activated_at: Time.zone.now)
end
>>>>>>> 48d8af7fadc1d463282cfa81e299fc5c346dcb90
10.times do |n|
  f_name  = Faker::Name.first_name
  l_name  = Faker::Name.last_name
  country_code = "US"
  email = "example-#{n+1}@fakeemail.org"
  password = "test"
  User.create(first_name:  f_name,
  			      last_name:  l_name,
  			      gender: "n/a",
              email: email,
              password:              password,
              password_confirmation: password,
              country_of_residence_code: country_code)
              activated: true,
              activated_at: Time.zone.now)
end
