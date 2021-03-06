class Trip 
  include Neo4j::ActiveNode

  attr_accessor :country_code , :check_box_country, :check_box_place, :check_box_date_from, :check_box_date_to

  property :place, type: String
  property :country, type: String
  property :date_from, type: Date
  property :date_to, type: Date
  property :description, type: String
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :user_uuid, type: String
  property :photo, type: String
  property :photo2, type: String
  property :photo3, type: String
  mount_uploader :photo, AssetUploader
  mount_uploader :photo2, AssetUploader
  mount_uploader :photo3, AssetUploader

  validates :place, presence: true
  validates :description, presence: true

  has_one :in, :plan, model_class: User, rel_class: Plan
  has_many :out, :plan, model_class: Country, rel_class: IsLocatedIn
  has_many :out, :trip_has_attached, model_class: CarrierwaveImage, rel_class: HasAttached, dependent: :destroy

  before_save { self.country ||= country_code_to_name }
  before_save :capitalize_place

  private

    def country_code_to_name
      country_name = ISO3166::Country[country_code]
      country_name.translations[I18n.locale.to_s] || country_name.name
    end

    def capitalize_place
      self.place = place.titleize
    end

end
