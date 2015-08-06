json.array!(@blogs) do |blog|
  json.extract! blog, :id, :name, :content, :title
  json.url blog_url(blog, format: :json)
end
