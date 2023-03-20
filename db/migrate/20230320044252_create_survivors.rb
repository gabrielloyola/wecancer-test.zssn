class CreateSurvivors < ActiveRecord::Migration[6.1]
  def change
    create_table :survivors do |t|
      t.string :name, null: false
      t.integer :age, null: false
      t.string :gender, null: false
      t.float :last_lat
      t.float :last_long

      t.timestamps
    end
  end
end
