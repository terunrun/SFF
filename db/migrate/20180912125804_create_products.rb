class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :user_id
      t.integer :category_id
      t.string :image
      t.string :description

      t.timestamps
    end
  end
end
