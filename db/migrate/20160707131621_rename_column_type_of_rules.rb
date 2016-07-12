class RenameColumnTypeOfRules < ActiveRecord::Migration
  def change
    rename_column :rules, :type, :rule_type
  end
end
