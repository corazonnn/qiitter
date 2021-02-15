class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy] #ログイン済みかどうかの確認
  def create
    @product = Product.find(params[:product_id])#投稿が失敗したときはrenderで飛ばされるからここにあらかじめインスタンスを準備しておく
    @comments = @product.comments.order(created_at: :desc)#同上
    @comment = current_user.comments.build(comment_params)#commentに必要な情報はuser_id,product_id,body。formから後者２つが送られてくるからあとはcurrent_userのidが欲しいだけ
    if @comment.save
      flash[:notice] = 'コメントを投稿しました'
      @product.create_notification_comment(current_user, @comment.id)
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = 'コメント投稿に失敗しました'
      render 'products/show'
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id],product_id: params[:product_id])#削除ボタンを押すということはそのcomment情報を渡してくるということ。つまりid,user_id,product_idが渡ってくる。
    if @comment.destroy
      redirect_to product_path(@comment.product)
    end
  end

  private

  def comment_params # ストロングパラメーター（予期しない値を変更されてしまう脆弱性を防ぐ機能）update,createなど値を変更する時。
   params.require(:comment).permit(:body, :product_id)
  end
end
