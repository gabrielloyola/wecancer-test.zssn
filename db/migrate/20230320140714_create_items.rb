class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false, index: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
