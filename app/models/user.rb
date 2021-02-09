class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  mount_uploader :image, ImageUploader #画像アップロード機能
  has_many :products, dependent: :destroy #オブジェクトが削除されたとき、それに紐づくオブジェクトも同時に削除する
  has_many :likes, dependent: :destroy
  has_many :likings, through: :likes, source: :product #likesテーブルを通して、いいねしているproductを参照する
  
  def like(product) #いいねする
    self.likes.find_or_create_by(product_id: product.id)
  end

  def unlike(product) #いいねを外す
    like = self.likes.find_by(product_id: product.id)
    like.destroy if like
  end
  def liked?(product) #既にいいねしているのかの確認
    self.likings.include?(product)
  end
end
