class RenameColumnRuleTypeOfRules < ActiveRecord::Migration
  def change
    rename_column :rules, :rule_type, :ruletype
  end
end
