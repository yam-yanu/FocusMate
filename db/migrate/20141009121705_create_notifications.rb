class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :level
      t.boolean :read_flag

      t.timestamps
    end
  end
end
