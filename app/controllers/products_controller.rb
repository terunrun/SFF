class ProductsController < ApplicationController
  before_action :authenticate_user!

  # ページネーション用
  PER = 10

  def index
    respond_to do |format|
      format.html do
        if !params[:search_name].blank? && !params[:search_date].blank? && params[:search_stock] == "1"
          session[:product_search_name] = params[:search_name]
          session[:product_search_date] = params[:search_date]
          session[:product_search_stock] = params[:search_stock]
          @products = Product.where("name LIKE ?", "%#{params[:search_name]}%")
                             .where(created_at: params[:search_date].in_time_zone.all_day)
                             .where.not(stock: 0)
                             .order(name: "ASC").page(params[:page]).per(PER)
        elsif !params[:search_name].blank?
          session[:product_search_name] = params[:search_name]
          if params[:search_stock] == "1"
            session[:product_search_stock] = params[:search_stock]
            @products = Product.where("name LIKE ?", "%#{params[:search_name]}%")
                               .where.not(stock: 0)
                               .order(name: "ASC").page(params[:page]).per(PER)
         else
            @products = Product.where("name LIKE ?", "%#{params[:search_name]}%")
                               .order(name: "ASC").page(params[:page]).per(PER)
         end
        elsif !params[:search_date].blank?
          session[:product_search_date] = params[:search_date]
          if params[:search_stock] == "1"
            session[:product_search_stock] = params[:search_stock]
            @products = Product.where(created_at: params[:search_date].in_time_zone.all_day)
                               .where.not(stock: 0)
                               .order(name: "ASC").page(params[:page]).per(PER)
          else
            @products = Product.where(created_at: params[:search_date].in_time_zone.all_day)
                               .order(name: "ASC").page(params[:page]).per(PER)
          end
        elsif params[:search_stock] == "1"
          session[:product_search_stock] = params[:search_stock]
          @products = Product.where.not(stock: 0).order(name: "ASC").page(params[:page]).per(PER)
        else
          session[:product_search_name] = nil
          session[:product_search_date] = nil
          session[:product_search_stock] = nil
          @products = Product.all.order(name: "ASC").page(params[:page]).per(PER)
        end
      end
      format.csv do
        if !params[:search_name].blank? && !params[:search_date].blank? && params[:search_stock] == "1"
          @products = Product.where("name LIKE ?", "%#{params[:product_search_name]}%")
                             .where(created_at: params[:product_search_date].in_time_zone.all_day)
                             .where.not(stock: 0)
                             .order(name: "ASC").page(params[:page]).per(PER)
        elsif !session[:product_search_name].blank?
          if params[:product_search_stock] == "1"
            @products = Product.where("name LIKE ?", "%#{params[:product_search_name]}%")
                               .where.not(stock: 0)
                               .order(name: "ASC").page(params[:page]).per(PER)
          else
            @products = Product.where("name LIKE ?", "%#{session[:product_search_name]}%")
                               .order(name: "ASC").page(params[:page]).per(PER)
          end
        elsif !session[:product_search_date].blank?
          if params[:product_search_stock] == "1"
            @products = Product.where(created_at: params[:product_search_date].in_time_zone.all_day)
                               .where.not(stock: 0)
                               .order(name: "ASC").page(params[:page]).per(PER)
          else
            @products = Product.where(created_at: params[:product_search_date].in_time_zone.all_day)
                               .order(name: "ASC").page(params[:page]).per(PER)
          end
        elsif session[:product_search_stock] == "1"
          @products = Product.where.not(stock: 0)
                             .order(name: "ASC").page(params[:page]).per(PER)
        else
          @products = Product.all.order(name: "ASC").page(params[:page]).per(PER)
        end
        send_data render_to_string, filename: "products.csv", type: :csv
#        products_csv
      end
    end
  end


  def show
    @product = Product.find(params[:id])
    @comment = Comment.new
    @comments = @product.comments
    @recommends = Product.where(category_id: @product.category_id)
                         .where.not(user_id: current_user.id)
                         .where.not(id: @product.id)
                         .order("RAND()").limit(5)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = params[:user_id]
    # @product.user = current_user
    if @product.save
      redirect_to products_path, notice: "商品を登録しました"
    else
      render :new, danger: "商品登録に失敗しました"
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      redirect_to product_path, notice: "商品情報を変更しました"
    else
      render "new", danger: "商品情報の変更に失敗しました"
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    redirect_to products_path, notice: "商品を削除しました"
  end

  private

    def product_params
      params.require(:product).permit(:name, :image, :description, :category_id, :stock, :price)
    end

    # def products_csv
    #   csv_date = CSV.generate do |csv|
    #     csv_column_names = ["商品名","説明","登録者","登録日"]
    #     csv << csv_column_names
    #     @products.each do |product|
    #       csv_column_values = [
    #         product.name,
    #         product.description,
    #         product.user.name,
    #         product.created_at,
    #       ]
    #       csv << csv_column_values
    #     end
    #   end
    #   send_data(csv_date,filename: "product.csv")
    # end

end
