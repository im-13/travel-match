class Blog 
  	include Neo4j::ActiveNode

	  attr_accessor :carrierwave_image_attributes, :asset, :remote_photo_url

  	property :user_gravatar_url, type: String
    property :user_name, type: String
  	property :user_uuid, type: String
    property :user_email, type: String
  	property :content, type: String
  	property :created_at, type: DateTime
  	property :updated_at, type: DateTime
    property :photo, type: String
    mount_uploader :photo, AssetUploader


  	has_many :in, :is_author_of, model_class: User, rel_class: IsAuthorOf
  	has_many :out, :has_attached, model_class: CarrierwaveImage, rel_class: HasAttached
    has_many :both, :has, model_class: Comment, rel_class: Has

    #accepts_nested_attributes_for :asset, :reject_if => proc { |attributes| attributes[:title].blank? }
end