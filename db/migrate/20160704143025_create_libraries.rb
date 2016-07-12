class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :name_sv
      t.string :name_en
      t.string :sigel
      t.timestamps null: false
    end
  end
end
