class AddDetailToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :detail, :string
  end
end
