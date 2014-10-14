class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.integer :level
      t.integer :required_exp
      t.string :degree
      t.timestamps
    end
  end
end
