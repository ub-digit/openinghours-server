require 'rails_helper'

RSpec.describe Library, type: :model do

  describe "default_scope" do
    it "should not return deleted libraries" do
      create(:library)
      create(:library, deleted_at: DateTime.yesterday)

      result = Library.all.count

      expect(result).to eq 1
    end
  end
  describe "name_sv" do
    it {should validate_presence_of(:name_sv)}
  end
  describe "name_en" do
    it {should validate_presence_of(:name_en)}
  end
  describe "rules" do
    it {should have_many(:rules)}
  end

  describe "rule_for_date" do
    context "there is no rule for the given date" do
      it "should return nil" do
        library = create(:library)

        result = library.rule_for_date(date: "2017-01-01")

        expect(result).to be nil
      end
    end
    context "there is one rule for the given date" do
      it "should return a rule object" do
        library = create(:library)
        rule = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-01-01"))

        result = library.rule_for_date(date: "2017-01-01")

        expect(result).to be_a Rule
        expect(result.id).to eq rule.id
      end
    end
    context "there are two rules for the given date" do
      it "should return the rule with the last startdate" do
        library = create(:library)
        rule1 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-01-01"))
        rule2 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-02-01"))

        result = library.rule_for_date(date: "2017-01-01")

        expect(result.id).to eq rule2.id
      end
    end
    context "there is an exception that starts before a regular rule for the given date" do
      it "should return the exception" do
        library = create(:library)
        rule1 = create(:rule, library: library, ruletype: "EXCEPTION", startdate: Date.parse("2016-01-01"), enddate: Date.parse("2016-03-01"))
        rule2 = create(:rule, library: library, ruletype: "REGULAR", startdate: Date.parse("2016-02-01"))

        result = library.rule_for_date(date: "2016-02-20")

        expect(result.id).to eq rule1.id
      end
    end
  end
end
