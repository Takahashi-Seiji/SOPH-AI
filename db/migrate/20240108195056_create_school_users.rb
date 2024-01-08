class CreateSchoolUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :school_users do |t|
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end
  end
end
