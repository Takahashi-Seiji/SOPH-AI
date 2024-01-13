class RemoveRoleFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_column :messages, :role
  end
end
