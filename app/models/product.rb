class Product < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps, source: :tag


  def save_tag(product_tags) #入力されたタグをそのプロダクトのタグに追加する。
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil? #編集用、新規作成どっちでもいける。もし現在のタグがあれば取得
    old_tags = current_tags - product_tags #今入力されたタグと、元々あったタグの差から消すべきタグ（編集によって）を決める
    new_tags = product_tags - current_tags #逆に編集前にはなかった新しいタグを取得する
    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old) #古いタグは消去する
    end
    new_tags.each do |new|
      new_product_tag = Tag.find_or_create_by(tag_name: new) #新しいタグはself.tagsにpushする。つまりself.tagsの中には常に新しいタグのみがある、
      self.tags << new_product_tag
    end
  end
end
