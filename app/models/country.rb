 class Country 
  include Neo4j::ActiveNode

  attr_accessor :country_of_residency, :country_visited, :country_to_visit

  property :name, type: String
  property :code, type: String
  has_many :in, :lives_in, model_class: User, rel_class: LivesIn
  has_many :in, :want_to_visit, model_class: User, rel_class: WantsToGoTo
  has_many :in, :has_visited, model_class: User, rel_class: HasBeenTo

  def set_code
  	c = ISO3166::Country.find_country_by_name(self.name)
  	self.code = c.alpha2
  end
end
