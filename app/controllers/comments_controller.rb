class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    @comment.product_id = params[:product_id]
    @comment.user_id = params[:user_id]
    if @comment.save
      # 追加コメントが表示されるよう、コメント一覧インスタンスを再作成
      @comments = Comment.where(product_id: @comment.product_id)
      respond_to do |format|
        format.html {redirect_to product_path(params[:product_id]), notice: "コメントを投稿しました"}
        format.js
      end
    else
      redirect_to product_path(params[:product_id]), danger: "コメントの投稿に失敗しました"
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    @comments = Comment.where(product_id: comment.product_id)
    respond_to do |format|
      format.html {redirect_to product_path(comment.product_id), notice: "コメントを削除しました"}
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
