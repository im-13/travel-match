json.array!(@carrierwave_images) do |carrierwave_image|
  json.extract! carrierwave_image, :id
  json.url carrierwave_image_url(carrierwave_image, format: :json)
end
