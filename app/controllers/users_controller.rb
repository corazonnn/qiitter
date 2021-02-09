class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :followings, :followers] #ログイン済みかどうかの確認
  def show
    @user = current_user
  end
  def followings #フォローしているユーザの一覧ページ
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page]).per(20)
    counts(@user) #application.controlersの中にメソッドがある
  end

  def followers #フォロワーの一覧ページ
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page]).per(20)
    counts(@user)
  end
end
