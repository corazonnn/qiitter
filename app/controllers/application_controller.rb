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
  def create_graph #棒グラフ
    if user_signed_in? #もしログインしているならプロダクトを古い順に並べて、それをループで回して、順番に＠dataに（作った時間,個数）を入れていく。
      @my_product = current_user.products.order(id: :asc).page(params[:page]).per(7)
      @product = current_user.products.order(id: :asc)
      if @product.present?
        @data = []
        @product.each_with_index do |product, idx|
          #@data = [['2019-06-01', 100], ['2019-06-02', 200], ['2019-06-03', 150]]
          @data.push [product.created_at.to_s(:datetime_jp), idx + 1]
        end
      end
    end
  end

  def create_pie_graph #円グラフとタグのパーセント
    if user_signed_in?
      #ここから円グラフ
      @my_product = current_user.products.order(id: :desc).page(params[:page]).per(7)
      products = current_user.products.all
      pie_graph_data = []
      @pie_data = {}
      products.each do |product|
        pie_graph_data << [product.tags.pluck(:tag_name)] #pie_graph_dataは[ [[]],[[]],[["Ruby","AWS"]],[["PHP","Python"]],[[]],[[]],[[]]]の状態
      end
      pie_graph_result = pie_graph_data.flatten #@pie_graph_resultは["AWS","PHP","Python","C","C++","Ruby"]
      pie_graph_result.each do |pie_res|
        if @pie_data.has_key?(pie_res)
          val = @pie_data[pie_res]
          @pie_data.store(pie_res, val + 1)
        else
          @pie_data.store(pie_res, 1)#@pie_dataは{"AWS"=>2,"Ruby"=>3,"Python"=>3,"PHP"=>1}タグとその個数
        end
      end
      #ここからタグのパーセント
      tag_count = @pie_data.values.inject(:+)#valueの合計の数をもらう
      @tag_percent_data = {}
      @pie_data.each{|key, value|
        value_percent = (value * 100)/tag_count
        value_percent = value_percent.floor
        @tag_percent_data.store(key, value_percent)
      }
      @tag_percent_data = @tag_percent_data.sort {|a,b| b[1]<=>a[1]}
      @tag_percent_data = @tag_percent_data.take(5).to_h
    end


  end
end
