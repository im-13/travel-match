class Comment 
  include Neo4j::ActiveNode
  
  attr_accessor :blog_id

  property :comment, type: String
  property :user_name, type: String
  property :user_uuid, type: String
  property :created_at, type: DateTime
  property :user_gravatar_url, type: String
  property :user_avatar_url, type: String
  property :photo, type: String
  mount_uploader :photo, AssetUploader

  has_one :in, :have, model_class: Blog, rel_class: Have
end
