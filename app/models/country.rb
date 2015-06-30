class Country 
  include Neo4j::ActiveNode
  property :name, type: String
  has_many :in, :lives_in, model_class: User
  has_many :in, :want_to_visit, model_class: User 
  has_many :in, :has_visited, model_class: User
end
