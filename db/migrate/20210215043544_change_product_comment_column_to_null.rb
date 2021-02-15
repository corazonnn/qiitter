class ChangeProductCommentColumnToNull < ActiveRecord::Migration[6.1]
  def up
    change_column_null :notifications, :product_id, true
    change_column_null :notifications, :comment_id, true
  end

  def down
    change_column_null :notifications, :product_id, false
    change_column_null :notifications, :comment_id, false
  end
end
