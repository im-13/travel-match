json.array!(@users) do |user|
  json.extract! user, :id, :fname, :lname, :email, :dob, :gender, :password_digest
  json.url user_url(user, format: :json)
end
