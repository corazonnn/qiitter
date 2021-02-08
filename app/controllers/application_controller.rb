class ApplicationController < ActionController::Base



  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name]) # 新規登録時(sign_up時)にnameというキーのパラメーターを追加で許可する
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :image])#ユーザ編集時にnameというキーのパラメーターを追加で許可する
  end

  def counts(user) #特定のuserのプロダクトの数を数える。
    @count_products = user.products.count
  end
end
