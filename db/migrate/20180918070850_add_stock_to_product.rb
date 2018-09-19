class AddStockToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :stock, :integer
  end
end
