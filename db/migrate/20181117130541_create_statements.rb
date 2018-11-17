class CreateStatements < ActiveRecord::Migration[5.2]
  def change
    create_table :statements do |t|
      t.string :name, null: false
      t.column :code, 'char(2)'

      t.index :code, unique: true
    end
  end
end
