class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = Comment.new(comment_params)
    @comment.product_id = params[:product_id]
    @comment.user_id = params[:user_id]
    if @comment.save
      redirect_to product_path(params[:product_id]), notice: "コメントを投稿しました"
    else
      redirect_to product_path(params[:product_id]), danger: "コメントの投稿に失敗しました"
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
