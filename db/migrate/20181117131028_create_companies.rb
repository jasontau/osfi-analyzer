class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.column :code, 'char(4)', null: false

      t.index :code, unique: true
    end
  end
end
