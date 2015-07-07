class CarrierwaveImage 
  include Neo4j::ActiveNode
  property :asset, type: String
  mount_uploader :asset, AssetUploader
end
