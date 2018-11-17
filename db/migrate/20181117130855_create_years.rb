class CreateYears < ActiveRecord::Migration[5.2]
  def change
    create_table :years do |t|
      t.column :year, 'char(2)', null: false

      t.index :year, unique: true
    end
  end
end
