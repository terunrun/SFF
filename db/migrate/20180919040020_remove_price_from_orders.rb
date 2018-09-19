class RemovePriceFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :price, :integer
  end
end
