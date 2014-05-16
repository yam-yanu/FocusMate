class CreateGreats < ActiveRecord::Migration
  def change
    create_table :greats do |t|
      t.integer :action_id
      t.integer :user_id

      t.timestamps
    end
  end
end
