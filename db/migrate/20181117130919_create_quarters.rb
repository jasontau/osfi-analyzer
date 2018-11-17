class CreateQuarters < ActiveRecord::Migration[5.2]
  def change
    create_table :quarters do |t|
      t.string :quarter

      t.timestamps
    end
  end
end
