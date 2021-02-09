class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy] #ログイン済みかどうかの確認
  def create
    product = Product.find(params[:product_id])
    current_user.like(product)
    flash[:notice] = 'いいねしました'
    redirect_to root_url
  end

  def destroy
    product = Product.find(params[:product_id])
    current_user.unlike(product)
    flash[:notice] = 'いいねを解除しました'
    redirect_to root_url
  end
end
