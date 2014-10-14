class AddColumnUsers < ActiveRecord::Migration
  def up
      add_column :users, :require_exp, :integer
      add_column :users, :level, :integer
    end
  
    def down
      add_column :users, :require_exp, :integer
      add_column :users, :level, :integer
  end
end
