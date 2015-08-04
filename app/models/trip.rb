class Trip 
  include Neo4j::ActiveNode

  attr_accessor :country_code 

  property :place, type: String
  property :country, type: String
  property :date_from, type: Date
  property :date_to, type: Date
  property :description, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :user_gravatar_url, type: String
    property :user_name, type: String
  	property :user_uuid, type: String
    property :user_email, type: String
  property :photo, type: String
  mount_uploader :photo, AssetUploader

  validates :place, presence: true
  validates :description, presence: true

  has_one :in, :plan, model_class: User, rel_class: Plan
  has_many :out, :plan, model_class: Country, rel_class: IsLocatedIn
  has_many :out, :trip_has_attached, model_class: CarrierwaveImage, rel_class: HasAttached, dependent: :destroy

  before_save { self.country = country_code_to_name }

  def country_code_to_name
    country_name = ISO3166::Country[country_code]
    country_name.translations[I18n.locale.to_s] || country_name.name
  end

end
