class Product < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
