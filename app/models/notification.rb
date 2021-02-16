class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) } #新着順で表示する
  belongs_to :visitor, class_name: "User", optional: true #optionnal:trueは空を許可するもの。フォロー通知のみではないので空の時もある。
  belongs_to :visited, class_name: "User", optional: true
  belongs_to :product, optional: true
  belongs_to :comment, optional: true
end
