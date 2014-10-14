class RenameRequireExpToUsers < ActiveRecord::Migration
  def up
    rename_column :users, :require_exp, :exp
  end
  def down
    rename_column :users, :exp, :require_exp
  end
end
