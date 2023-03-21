class InsertItems < ActiveRecord::Migration[6.1]
  def change
    items = [
      { name: 'Água', value: 4 },
      { name: 'Comida', value: 3 },
      { name: 'Remédio', value: 2 },
      { name: 'Munição', value: 1 }
    ]

    items.each { |item| Item.create(item) }
  end
end
