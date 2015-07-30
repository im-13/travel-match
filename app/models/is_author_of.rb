class IsAuthorOf 
  include Neo4j::ActiveRel

  from_class User
  to_class Blog

  type 'is_author_of'

  property :created_at, type: DateTime
  property :comments

  serialize :comments

end
