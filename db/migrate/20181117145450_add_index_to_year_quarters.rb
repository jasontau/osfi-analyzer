class AddIndexToYearQuarters < ActiveRecord::Migration[5.2]
  def change
    add_index :year_quarters, [:year_id, :quarter_id], unique: true
  end
end
