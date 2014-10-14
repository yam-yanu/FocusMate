class AddColumnGroups < ActiveRecord::Migration
  def up
      add_column :groups, :game_flag, :boolean
    end
  
    def down
      add_column :groups, :game_flag, :boolean
  end
end
