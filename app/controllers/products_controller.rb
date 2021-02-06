class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :destroy, :edit, :update] #ログイン済みかどうかの確認
  before_action :correct_user, only: [:destroy, :edit, :update] #本人確認
  def index
    @products = Product.order(id: :desc) #.page(params[:page])
  end
  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = current_user.products.build
  end

  def edit #本人確認
  end

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      flash[:notice] = '新規作成できました'
      redirect_to @product
    else
      flash.now[:alert] = '作成できませんでした'
      render :new
    end
  end
  def update #本人確認
   if @product.update(product_params)
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

  private  # ストロングパラメーター（予期しない値を変更されてしまう脆弱性を防ぐ機能）

  def product_params
   params.require(:product).permit(:title, :body)
  end

  def correct_user #編集、更新、削除しようとしているプロダクトのidを現在のユーザのDBから探してくる。なければリダイレクト
    @product = current_user.products.find_by(id: params[:id]) #find_by使う時：そのプロダクトが存在しているかわからない時。つまり、current_user内から探している時。
    unless @product
      redirect_to root_url
    end
  end
end
