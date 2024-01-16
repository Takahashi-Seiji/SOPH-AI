class AddDateToReminders < ActiveRecord::Migration[7.1]
  def change
    add_column :reminders, :date, :datetime
  end
end
