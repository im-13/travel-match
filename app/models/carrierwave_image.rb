class CarrierwaveImage 
  include Neo4j::ActiveNode
  property :asset, type: String
  mount_uploader :asset, AssetUploader

  #has_many :in, :has_attached, model_class: Blog
end
