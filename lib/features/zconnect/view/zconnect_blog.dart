import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zilogic/constants/assets_constants.dart';
import 'package:zilogic/features/auth/controller/auth_controller.dart';
import 'package:zilogic/features/zconnect/controller/zconnect_controller.dart';
import 'package:zilogic/models/zconnect_model.dart';
import 'package:zilogic/theme/theme.dart';

class ZconnectBlog extends ConsumerWidget {
  final ZConnectModel _blog;
  static route(ZConnectModel blog) => MaterialPageRoute(
      builder: (context) => ZconnectBlog(
            blog: blog,
          ));

  const ZconnectBlog({required ZConnectModel blog, super.key}) : _blog = blog;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value!;

    return Scaffold(
      appBar: AppBar(
        actions: [
          LikeButton(
            padding: const EdgeInsets.all(10),
            size: 25,
            onTap: (isLiked) async {
              ref.read(zconnectControllerProvider.notifier).likeBlog(
                    _blog,
                    currentUser,
                  );
              return !isLiked;
            },
            isLiked: _blog.likes.contains(currentUser.uid),
            likeBuilder: (isLiked) {
              return isLiked
                  ? SvgPicture.asset(
                      AssetsConstants.likeFilledIcon,
                      color: Pallete.redColor,
                    )
                  : SvgPicture.asset(
                      AssetsConstants.likeOutlinedIcon,
                      color: Pallete.greyColor,
                    );
            },
            likeCount: _blog.likes.length,
            countBuilder: (likeCount, isLiked, text) {
              return Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isLiked ? Pallete.redColor : Pallete.whiteColor,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: InteractiveViewer(
          maxScale: 5.0,
          minScale: 1.0,
          alignment: Alignment.center,
          child: Markdown(
            data: _blog.blogContent,
            onTapLink: (text, href, title) async {
              await launchUrl(
                Uri.parse(href!),
                mode: LaunchMode.platformDefault,
                webOnlyWindowName: text,
              );
            },
            onTapText: () {
              print("Text Pressed");
            },
          ),
        ),
      ),
    );
  }
}
