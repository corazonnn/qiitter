class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  validates :name, presence: true
  mount_uploader :image, ImageUploader #画像アップロード機能
  has_many :products, dependent: :destroy #オブジェクトが削除されたとき、それに紐づくオブジェクトも同時に削除する
end
