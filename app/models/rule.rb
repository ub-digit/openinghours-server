class Rule < ActiveRecord::Base
  belongs_to :library
  has_many :opening_hours

  validates :library, presence: true
  validates :startdate, presence: true
  validates :enddate, presence: true, :if => :is_exception?
  validate :validate_enddate_not_before_startdate
  validates_inclusion_of :ruletype, in: ["REGULAR", "EXCEPTION"]

  def is_exception?
    ruletype == "EXCEPTION"
  end

  def validate_enddate_not_before_startdate
    if enddate.present? && enddate < startdate
      errors.add(:enddate, "cannot be before start date")
    end
  end
end
