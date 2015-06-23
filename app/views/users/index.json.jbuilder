json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :email, :date_of_birth, :gender, :password_hash, :country_of_residency, :password, :password_confirmation
  json.url user_url(user, format: :json)
end
