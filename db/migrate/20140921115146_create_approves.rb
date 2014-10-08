class CreateApproves < ActiveRecord::Migration
  def change
    create_table :approves do |t|
      t.integer :approve_user_id
      t.integer :approved_user_id
      t.integer :type

      t.timestamps
    end
  end
end
