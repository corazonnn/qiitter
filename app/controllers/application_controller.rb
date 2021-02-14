class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name]) # 新規登録時(sign_up時)にname(追加したカラム)というパラメーターを追加で許可する
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :image])#ユーザ編集時にnameと,imageいうパラメーターを追加で許可する
  end

  def products_counts(user) #特定のuserのプロダクトの数を数える。
    @count_products = user.products.count
  end
  def followings_counts(user) #特定のuserのフォロー数を数える。
    @count_followings = user.followings.count
  end
  def followers_counts(user) #特定のuserのフォロワーを数える。
    @count_followers = user.followers.count
  end
  def sort_change(keyword)
    if keyword == "new" || keyword == nil
      @products = Product.order(id: :desc).page(params[:page]).per(7)
    elsif keyword == "old"
      @products = Product.order(id: :asc).page(params[:page]).per(7)
    elsif keyword == "like"
      products = Product.includes(:likes).sort {|a,b| b.likes.size <=> a.likes.size}#Productの内likesがあるものの中からいいねの多い順に並び替える
      @products = Kaminari.paginate_array(products).page(params[:page]).per(7)
    end
  end
end
