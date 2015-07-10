json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :email, :date_of_birth, :gender, :password_hash, :remember_hash, :country_of_residence_code, :password, :password_confirmation, :about_me
  json.url user_url(user, format: :json)
end
