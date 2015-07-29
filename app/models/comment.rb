class Comment 
  include Neo4j::ActiveNode
  property :comment, type: String
  property :blog, type: String
  property :user, type: String

  has_many :both, :has, model_class: Blog, rel_class: Has
end
