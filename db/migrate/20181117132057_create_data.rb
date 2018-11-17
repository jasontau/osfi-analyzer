class CreateData < ActiveRecord::Migration[5.2]
  def change
    create_table :data do |t|
      t.integer :row, null: false
      t.integer :column, null: false
      t.decimal :value, null: false
      t.references :statement, foreign_key: true
      t.references :year, foreign_key: true
      t.references :quarter, foreign_key: true
      t.references :company, foreign_key: true
      t.references :page, foreign_key: true
    end
  end
end
