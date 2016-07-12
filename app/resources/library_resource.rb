class LibraryResource < JSONAPI::Resource
  attributes :name_sv, :name_en, :sigel

  has_many :rules
end
