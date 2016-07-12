require 'rails_helper'

RSpec.describe Rule, type: :model do
  describe "library" do
    it {should belong_to(:library)}
  end
  describe "startdate" do
    it {should validate_presence_of(:startdate)}
  end
  describe "enddate" do
    context "for a rule that is an exception" do
      subject { build(:rule, ruletype: "EXCEPTION") }
      it {should validate_presence_of(:enddate)}
    end
    context "for a rule that is a regular rule" do
      subject { build(:rule, ruletype: "REGULAR") }
      it {should_not validate_presence_of(:enddate)}
    end
    context "for a startdate set today" do
      subject { build(:rule, startdate: Date.today) }
      it {should allow_value(Date.today + 1).for(:enddate)}
      it {should_not allow_value(Date.today - 1).for(:enddate).with_message("cannot be before start date")}
    end
  end
  describe "ruletype" do
    # bug in shoulda
    #it {should validate_inclusion_of(:type).in_array(["REGULAR", "EXCEPTION"])}
  end
  describe "opening_hours" do
    it {should have_many(:opening_hours)}
  end
end
