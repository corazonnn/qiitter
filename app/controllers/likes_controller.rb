class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy] #ログイン済みかどうかの確認
  def create
    @product = Product.find(params[:product_id])
    current_user.like(@product) #likeメソッド
    @product.create_notification_like(current_user)
    #redirect_to root_url（ajaxを使用しているから消す）
  end

  def destroy
    @product = Product.find(params[:product_id])
    current_user.unlike(@product)
    #redirect_to root_url（ajaxを使用しているから消す）
  end
end
