class CarrierwaveImage 
  include Neo4j::ActiveNode

  attr_accessor :blog_id
 
  property :asset, type: String
  mount_uploader :asset, AssetUploader
  property :user_name, type: String
  property :user_uuid, type: String
  property :created_at, type: DateTime
  property :user_gravatar_url, type: String
  property :user_avatar_url, type: String

  has_one :in, :has_attached, model_class: Blog, rel_class: HasAttached
  has_many :in, :trip_has_attached, model_class: Trip, rel_class: TripHasAttached

end