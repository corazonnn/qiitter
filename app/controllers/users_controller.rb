class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :followings, :followers] #ログイン済みかどうかの確認

  def show
    @user = User.find(params[:id])
    products_counts(@user)#application.controlersの中にメソッドがある
    followings_counts(@user)
    followers_counts(@user)
    create_graph(@user)#棒グラフの作成
    create_pie_graph(@user)#円グラフ
    @my_product = @user.products.order(id: :desc).page(params[:page]).per(7)
  end
  
  def followings #フォローしているユーザの一覧ページ
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page]).per(20)
    products_counts(@user)
    followings_counts(@user)
    followers_counts(@user)
  end

  def followers #フォロワーの一覧ページ
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page]).per(20)
    products_counts(@user)
    followings_counts(@user)
    followers_counts(@user)
  end
  def likings
    @user = User.find(params[:id])
    @likings = @user.likings.page(params[:page]).per(7)
  end
end
