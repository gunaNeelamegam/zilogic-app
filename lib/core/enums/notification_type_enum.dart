enum NotificationType {
  like('like'),
  reply('reply'),
  follow('follow'),
  retweet('retweet'),
  blog("blog");

  final String type;
  const NotificationType(this.type);
}

extension ConvertTweet on String {
  NotificationType toNotificationTypeEnum() {
    switch (this) {
      case 'retweet':
        return NotificationType.retweet;
      case 'follow':
        return NotificationType.follow;
      case 'reply':
        return NotificationType.reply;
      default:
        return NotificationType.like;
    }
  }
}
