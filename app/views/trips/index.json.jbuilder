json.array!(@trips) do |trip|
  json.extract! trip, :id, :place
  json.url trip_url(trip, format: :json)
end
