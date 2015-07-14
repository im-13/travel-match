class AddAvatarToUser 
  include Neo4j::ActiveNode
  property :asset, type: String
  mount_uploader :asset, AssetUploader
  #has_one :in, :asset, model_class: User
end
