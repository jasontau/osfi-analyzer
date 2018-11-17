class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :name, null: false
      t.string :code, 'char(4)', null: false, unique: true
    end
  end
end
