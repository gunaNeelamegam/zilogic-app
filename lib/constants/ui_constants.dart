import 'package:flutter/material.dart';
import 'package:zilogic/constants/constants.dart';
import 'package:zilogic/features/explore/view/explore_view.dart';
import 'package:zilogic/features/notifications/views/notification_view.dart';
import 'package:zilogic/features/tweet/widgets/tweet_list.dart';
import 'package:zilogic/theme/pallete.dart';

class UIConstants {
  static AppBar appBar({
    String titleImage = AssetsConstants.zilogicLogo,
  }) {
    return AppBar(
      title: Image.asset(
        titleImage,
        color: Pallete.orangeColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    ExploreView(),
    NotificationView(),
  ];
}
