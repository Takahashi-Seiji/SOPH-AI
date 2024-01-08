class AddAverageToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :average, :float
  end
end
