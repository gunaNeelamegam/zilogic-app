import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zilogic/features/zconnect/view/zconnect_blog.dart';
import 'package:zilogic/models/zconnect_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zilogic/theme/theme.dart';

class ZConnectCard extends ConsumerWidget {
  final ZConnectModel blog;
  const ZConnectCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, ZconnectBlog.route(blog));
      },
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: MediaQuery.sizeOf(context).width * 0.9,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Pallete.orangeColor,
                Pallete.backgroundColor,
              ],
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: MediaQuery.sizeOf(context).height / 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ListTile(
                title: Text(
                  blog.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'author : ${blog.authorName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      'published: ${timeago.format(blog.uploadedAt, locale: "en_short")}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
