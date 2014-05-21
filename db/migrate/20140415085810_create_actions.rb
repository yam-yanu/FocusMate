class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :who
      t.datetime :act_time
      t.string :where
      t.string :what
      t.integer :author

      t.timestamps
    end
  end
end
