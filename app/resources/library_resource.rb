class LibraryResource < JSONAPI::Resource
  attributes :name_sv, :name_en, :sigel
  attribute :next_seven_days

  has_many :rules

  def custom_links(options)
    { nextsevendays: options[:serializer].link_builder.self_link(self) + "/nextsevendays" }
  end

  def next_seven_days
    @model.opening_hours_for_interval(from_date: Date.today.strftime("%F"), number_of_days: 7)
  end
end
