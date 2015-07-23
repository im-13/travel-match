class Blog 
  	include Neo4j::ActiveNode

	  attr_accessor :carrierwave_image_attributes

  	property :user_gravatar_url, type: String
    property :user_name, type: String
  	property :user_uuid, type: String
    property :user_email, type: String
  	property :content, type: String
  	property :created_at, type: DateTime
  	property :updated_at, type: DateTime
    property :image, type: String
    mount_uploader :image, AssetUploader

  	has_many :in, :is_author_of, model_class: User, rel_class: IsAuthorOf
  	has_many :out, :has_attached, model_class: CarrierwaveImage, rel_class: HasAttached

    #accepts_nested_attributes_for :asset, :reject_if => proc { |attributes| attributes[:title].blank? }
end