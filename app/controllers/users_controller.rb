class UsersController < ApplicationController
  def show
    @user = current_user
  end
  def likings
    @user = User.find(params[:id])
    @likings = @user.likings.page(params[:page])
  end
end
