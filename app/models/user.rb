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

  has_many :relationships #自分がフォローしている人への参照
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id' #自分をフォローしている人(フォロワー)への参照
  #これではあくまでRelationshipモデルへの参照であるため、userがRelationshipをいくつ持っているかしかわからない。つまり誰をフォローしているのか、その奥の情報がない。
  has_many :followings, through: :relationships, source: :follow #Relationshipモデルのfollow_idを参照する
  has_many :followers, through: :reverses_of_relationship, source: :user #Relationshipモデルのuser_idを参照する

  has_many :comments, dependent: :destroy


  has_many :active_notifications, class_name: "Notification", foreign_key:"visitor_id", dependent: :destroy #送った通知の参照
  has_many :passive_notifications, class_name: "Notification", foreign_key:"visited_id", dependent: :destroy #送られた通知の参照

  def like(product) #いいねする
    if product.present?
      self.likes.find_or_create_by(product_id: product.id)
    end
  end

  def unlike(product) #いいねを外す
    if product.present?
      like = self.likes.find_by(product_id: product.id)
      like.destroy if like
    end
  end
  def liked?(product) #既にいいねしているのかの確認
    self.likings.include?(product)
  end

  def follow(other_user) #フォローするメソッド
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)#フォローを外すメソッド
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user) #フォローしているのかの確認
    self.followings.include?(other_user)
  end

  def create_notification_follow(current_user)
    notification = current_user.active_notifications.new(
      visited_id: id,
      action: 'follow'
    )
    notification.save if notification.valid?
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

end
