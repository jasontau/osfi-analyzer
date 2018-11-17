class CreateQuarters < ActiveRecord::Migration[5.2]
  def change
    create_table :quarters do |t|
      t.column :quarter, 'char(1)', null: false
      
      t.index :quarter, unique: true
    end
  end
end
