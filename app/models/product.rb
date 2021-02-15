class Product < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps, source: :tag
  has_many :notifications, dependent: :destroy

  def save_tag(product_tags) #formから入力されたタグを追加する。
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil? #編集用、新規作成どっちでもいける。もし現在のタグがあれば取得
    old_tags = current_tags - product_tags #(今入力されたタグ)-(元々あったタグ)から消すべきタグを決める
    new_tags = product_tags - current_tags #逆に編集前にはなかった新しいタグを取得する
    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old) #古いタグの消去
    end
    new_tags.each do |new|
      new_product_tag = Tag.find_or_create_by(tag_name: new) #新しいタグはself.tagsにpushする。つまりself.tagsの中には常に新しいタグのみがある、
      self.tags << new_product_tag
    end
  end
  def create_notification_like(current_user)#いいね通知の作成
    notification = current_user.active_notifications.new(
      comment_id: nil,
      product_id: id,      #@product.create_notification_like(current_user)で呼び出した時の@productのid。つまりいいねを押された投稿のid。
      visited_id: user_id, #@productに紐づいているuser_idはいいねされた投稿を作成したuserのid
      action: 'like'
      )
    if notification.visitor_id == notification.visited_id #もしいいねを押したのが自分なら通知は送らない。
       notification.checked = true
    end
    notification.save if notification.valid? #valid?:エラーが無い場合
  end

  def create_notification_comment(current_user, comment_id)#コメント通知の作成
    #同じ投稿にコメントしているユーザに通知を送る。（current_userと投稿ユーザーのぞく）
    temp_ids = Comment.where(product_id: id).select(:user_id).where.not("user_id = ? or user_id = ?", current_user.id, user_id).distinct #distinct:重複なし。つまり同じ投稿に複数回コメントをしている人も一回だけの通知
    temp_ids.each do |temp_id| #取得したユーザー達へ通知を作成。（user_idのみ繰り返し取得）
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    #投稿者へ通知を作成
    save_notification_comment(current_user, comment_id, user_id)
  end

  def save_notification_comment(current_user, comment_id, visited_id)#(通知をした人,通知されたコメント,通知された人)
    notification = current_user.active_notifications.new(
      product_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
