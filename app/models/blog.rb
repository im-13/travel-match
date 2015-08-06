class Blog 
  	include Neo4j::ActiveNode

	  attr_accessor :carrierwave_image_attributes, :asset, :remote_photo_url

  	property :user_gravatar_url, type: String
    property :user_name, type: String
  	property :user_uuid, type: String
    property :user_email, type: String
    property :title, type: String
  	property :content, type: String
  	property :created_at, type: DateTime
  	property :updated_at, type: DateTime
    property :photo, type: String
    property :photo2, type: String
    property :photo3, type: String
    property :count_comments, type: Integer, default: 0
    mount_uploader :photo, AssetUploader
    mount_uploader :photo2, AssetUploader
    mount_uploader :photo3, AssetUploader

    validates :content, presence: true

  	has_many :in, :is_author_of, model_class: User, rel_class: IsAuthorOf
  	has_many :out, :has_attached, model_class: CarrierwaveImage, rel_class: HasAttached, dependent: :destroy
    has_many :out, :have, model_class: Comment, rel_class: Have, dependent: :destroy

    #accepts_nested_attributes_for :asset, :reject_if => proc { |attributes| attributes[:title].blank? }
end