class RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy] #ログイン済みかどうかの確認
  def create
    @user = User.find(params[:follow_id])#params[:follow_id]はform_withで入力されたfollow_idタグを参照する
    current_user.follow(@user)
    flash[:notice] = 'フォローしました'
    @user.create_notification_follow(current_user)
    redirect_to root_url
  end

  def destroy
    user = User.find(params[:follow_id])
    current_user.unfollow(user)
    flash[:notice] = 'フォローを解除しました'
    redirect_to root_url
  end
end
