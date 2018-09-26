class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.integer :total_price, default: 0
      # t.references :product, foreign_key: true
      # t.integer :price
      # t.integer :number

      t.timestamps
    end
  end
end
