class DropGroups < ActiveRecord::Migration[7.1]
  def change
    drop_table :groups
  end
end
