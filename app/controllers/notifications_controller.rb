class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications #ユーザが受け取る通知全て
    @notifications.where(checked: false).each do |notification| #indexページを開いた瞬間に通知のcheckedは全てtrueに変える
      notification.update(checked: true)
    end
  end
  def destroy
    @notifications =current_user.passive_notifications.destroy_all #この時点でpassive_notificaitonsはあるの？
    redirect_to notifications_path
  end

end
