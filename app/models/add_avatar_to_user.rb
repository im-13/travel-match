class AddAvatarToUser 
  include Neo4j::ActiveRel
  require 'date'

  #property :asset, type: String
  #mount_uploader :asset, AssetUploader
  #has_one :in, :asset, model_class: User

  before_save :stamp
  from_class User
  to_class CarrierwaveImage
  type 'has_attached'
 
  property :date_created, type: Date
  property :comments

  serialize :comments

  def stamp
  	time = Time.now.to_s
	  time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M")
	  self.date_created = time
  end
end

end
