class CreateActionWhos < ActiveRecord::Migration
  def change
    create_table :action_whos do |t|
      t.integer :action_id
      t.integer :user_id

      t.timestamps
    end
  end
end
