class CreatePageviews < ActiveRecord::Migration
  def change
    create_table :pageviews do |t|
      t.integer :user_id
      t.integer :request_page
      t.integer :user_agent

      t.timestamps
    end
  end
end
