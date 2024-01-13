class AddSummaryToLecture < ActiveRecord::Migration[7.1]
  def change
    add_column :lectures, :summary, :string
  end
end
