class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :action_id
      t.integer :author_id
      t.text :comment

      t.timestamps
    end
  end
end
