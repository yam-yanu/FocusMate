class AddMailCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mail_count, :integer
  end
end
