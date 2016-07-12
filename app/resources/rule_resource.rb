class RuleResource < JSONAPI::Resource
  attributes :name_sv, :name_en, :description_sv, :description_en, :startdate, :enddate, :ruletype

  has_one :library
  has_many :opening_hours
end
