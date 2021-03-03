class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :destroy, :edit, :update] #ログイン済みかどうかの確認
  before_action :correct_user, only: [:destroy, :edit, :update] #本人確認
  before_action -> { create_graph(current_user) }, only: [:index, :search] #棒グラフの作成
  before_action -> { create_pie_graph(current_user) }, only: [:search, :graph, :index] #円グラフの作成




  before_action :all_users_products, only: [:index, :search, :graph]
  def index
    @products = Product.order(id: :desc).page(params[:page]).per(5)
    if current_user.present?#投稿数、いいねされた数の取得をする
      products_counts(current_user)#投稿数
      @user_products = current_user.products
      @like_count = 0
      @user_products.each do |product|
        @like_count += product.likes.count #いいねされた数の取得をする
      end
    end
    #棒、円グラフの作成
  end
  def show
    @product = Product.find(params[:id])
    @comment = Comment.new
    @comments = @product.comments.order(created_at: :desc)
    @product_tags = @product.tags
  end

  def new
    @product = current_user.products.build
  end

  def edit #本人確認
  end

  def create
    @product = current_user.products.build(product_params)
    tag_list = params[:product][:tag_name].split(",")
    if @product.save
      @product.save_tag(tag_list) #save_tagメソッドはproductモデルファイルの中
      flash[:notice] = '新規作成できました'
      redirect_to @product
    else
      flash.now[:alert] = '作成できませんでした'
      render :new
    end
  end
  def update #本人確認
    tag_list = params[:product][:tag_name].split(",")
   if @product.update(product_params)
     @product.save_tag(tag_list) #save_tagメソッドはproductモデルファイルの中
     flash[:notice] = '正常に更新されました'
     redirect_to @product
   else
     flash.now[:alert] = '更新に失敗しました'
     render :edit
   end
  end

  def destroy #本人確認
    if @product.destroy
      flash[:notice] = '正常に削除できました'
      redirect_to root_path
    else
      flash.now[:alert] = '削除に失敗しました'
      render :show
    end
  end
  def search
    @sort_keyword = params[:keyword]
    sort_change(@sort_keyword)
    #グラフの作成
  end
  def graph
    @products = Product.order(id: :desc).page(params[:page]).per(5)
    #グラフの作成
  end

  private

  def product_params # ストロングパラメーター（予期しない値を変更されてしまう脆弱性を防ぐ機能）update,createなど値を変更する時。
   params.require(:product).permit(:title, :body)
  end

  def correct_user #編集、更新、削除しようとしているプロダクトのidを現在のユーザのDBから探してくる。なければリダイレクト
    @product = current_user.products.find_by(id: params[:id]) #find_by使う時：そのプロダクトが存在しているかわからない時。つまり、current_user内から探している時。
    unless @product
      redirect_to root_url
    end
  end

  def all_users_products
    @all_products = Product.all.count
    @all_users = User.all.count
  end
end
