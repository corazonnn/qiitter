module NotificationsHelper
  def notification_form(notification)#通知内容の表示
      @visitor = notification.visitor
      @comment = nil
      your_item = link_to 'あなたの投稿', product_path(notification), style:"font-weight: bold;"
      @visiter_comment = notification.comment_id
      #notification.actionがfollowかlikeかcommentか
      case notification.action
        when "follow" then
          tag.a(notification.visitor.name, href:user_path(@visitor), style:"font-weight: bold;")+"があなたをフォローしました"
        when "like" then
          tag.a(notification.visitor.name, href:user_path(@visitor), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:product_path(notification.product_id), style:"font-weight: bold;")+"にいいねしました"
        when "comment" then
            @comment = Comment.find_by(id: @visiter_comment)&.body
            tag.a(@visitor.name, href:user_path(@visitor), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:product_path(notification.product_id), style:"font-weight: bold;")+"にコメントしました"
      end
    end
end
