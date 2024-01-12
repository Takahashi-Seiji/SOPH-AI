class AddRoleToMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :role, :integer
  end
end
