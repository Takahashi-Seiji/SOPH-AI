class AddInstitutionToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :institution, :string
  end
end
