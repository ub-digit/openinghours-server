class Library < ActiveRecord::Base
default_scope {where(deleted_at: nil)}

  has_many :rules

  validates :name_sv, presence: true
  validates :name_en, presence: true

  def rule_for_date(date:)

    active_rules = self.rules.where("startdate <= ?", date).where("enddate >= ? OR enddate IS NULL", date)
    # sorting assumes "exception" to be alphabetically before "regular"
    active_rules = active_rules.order(ruletype: :asc)
    active_rules = active_rules.order(startdate: :desc)

    return active_rules.first

  end
end
