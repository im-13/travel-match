class Country 
  include Neo4j::ActiveNode
  property :name, type: String
  has_many :in, :lives_in, model_class: User
end
