class CreateYearQuarters < ActiveRecord::Migration[5.2]
  def change
    create_table :year_quarters do |t|
      t.references :year, foreign_key: true, null: false
      t.references :quarter, foreign_key: true, null: false
    end
  end
end
