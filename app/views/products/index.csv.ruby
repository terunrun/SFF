require 'csv'

CSV.generate do |csv|
  csv_column_names = ["商品名","カテゴリー","登録者","在庫数","説明","登録日"]
  csv << csv_column_names
  @products.each do |product|
    csv_column_values = [
      product.name,
      product.category.name,
      product.user.name,
      product.stock,
      product.description,
      product.created_at,
    ]
    csv << csv_column_values
  end
end
