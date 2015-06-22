json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :email, :date_of_birth, :gender, :password_hash, :password_salt
  json.url user_url(user, format: :json)
end
