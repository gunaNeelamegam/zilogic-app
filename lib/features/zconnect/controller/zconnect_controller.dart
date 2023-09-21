import 'dart:io' as IO;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zilogic/apis/notification_api.dart';
import 'package:zilogic/apis/user_api.dart';
import 'package:zilogic/apis/zconnect_api.dart';
import 'package:zilogic/constants/appwrite_constants.dart';
import 'package:zilogic/core/enums/notification_type_enum.dart';
import 'package:zilogic/core/providers.dart';
import 'package:zilogic/core/utils.dart';
import 'package:zilogic/models/notification_model.dart' as models;
import 'package:zilogic/models/user_model.dart';
import 'package:zilogic/models/zconnect_model.dart';

final zconnectControllerProvider =
    StateNotifierProvider<ZConnectController, bool>((ref) {
  return ZConnectController(
      zconnectAPI: ref.watch(ZConnectApiProvider),
      notification: ref.watch(notificationAPIProvider),
      db: ref.watch(appwriteDatabaseProvider),
      userAPI: ref.watch(userAPIProvider));
});

final getBlogProvider = FutureProvider((ref) {
  return ref.watch(zconnectControllerProvider.notifier).getBlogs();
});

final getLatestBlogProvider = StreamProvider((ref) {
  return ref.watch(ZConnectApiProvider).getLatestBlog();
});

class ZConnectController extends StateNotifier<bool> {
  final ZconnectAPI _zconnectAPI;
  final NotificationAPI _notificationAPI;
  final UserAPI _userAPI;

  ZConnectController(
      {required Databases db,
      required ZconnectAPI zconnectAPI,
      required NotificationAPI notification,
      required UserAPI userAPI})
      : _zconnectAPI = zconnectAPI,
        _notificationAPI = notification,
        _userAPI = userAPI,
        super(false);

  void uploadBlog(
      {required IO.File blogFile,
      required String author,
      required String title,
      required String authorName,
      required String currentUserId,
      required BuildContext context}) async {
    final File file = await _zconnectAPI.storeToBlogBucket(blogFile);
    final ZConnectModel model = ZConnectModel(
        uid: currentUserId,
        likes: [],
        title: title,
        authorName: authorName,
        comments: [],
        blogUrl: AppwriteConstants.blogUrl(file.$id),
        uploadedAt: DateTime.now());
    final res = await _zconnectAPI.uploadBlog(model);
    res.fold((l) {
      showSnackBar(context, l.toString());
      return;
    }, (r) async {
      final users = await _userAPI.getAllUsers();
      await Future.wait(users.map((user) async {
        final models.Notification notification = models.Notification(
            text: "$authorName who published article title as $title .",
            postId: r.$id,
            id: ID.unique(),
            uid: user.$id,
            notificationType: NotificationType.blog);
        final res = await _notificationAPI.createNotification(notification);
        res.fold((l) {
          return showSnackBar(context, notification.text);
        }, (r) => ());
      }));
    });
  }

  void deleteBlogById(String id, BuildContext context) async {
    try {
      bool isDeleted = await _zconnectAPI.deleteBlog(id);
      if (isDeleted) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, "deleted successfully ");
        return;
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, "deleted failed ");
        return;
      }
    } catch (e, _) {
      return;
    }
  }

  void deletedAllBlog(BuildContext context) async {
    try {
      final bool isDeleted = await _zconnectAPI.deleteAllBlog();
      if (isDeleted) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, "deleted successfully ");
        return;
      } else {
        // ignore: use_build_context_synchronously
        showSnackBar(context, "deleted failed ");
        return;
      }
    } catch (e, _) {
      return;
    }
  }

  Future<List<ZConnectModel>> getBlogs() async {
    final zconnectBlogs = await _zconnectAPI.getAllBlogs();
    return await Future.wait(zconnectBlogs.map((e) async {
      return await ZConnectModel.fromMap(e.data);
    }).toList());
  }

  void likeBlog(ZConnectModel blog, UserModel user) async {
    List<String> likes = blog.likes;

    if (blog.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    blog = blog.copyWith(likes: likes);
    final res = await _zconnectAPI.likeBlog(blog);
    res.fold((l) => null, (r) async {
      final models.Notification notification = models.Notification(
        id: ID.unique(),
        notificationType: NotificationType.blog,
        postId: blog.id,
        text: "${user.name} liked the blog",
        uid: blog.uid,
      );
      await _notificationAPI.createNotification(notification);
    });
  }
}
