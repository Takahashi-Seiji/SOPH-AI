class AddContentToNote < ActiveRecord::Migration[7.1]
  def change
    add_column :notes, :content, :string
  end
end
