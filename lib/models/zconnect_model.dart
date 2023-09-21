// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<String> getBlogContent(String blogUrl) async {
  String blogContent = "";
  try {
    final response = await http.get(Uri.parse(blogUrl));

    if (response.statusCode == 200) {
      blogContent = response.body;
    }
  } catch (error, stackTrace) {
    debugPrint("$error ${stackTrace.toString()}");
  }
  return blogContent;
}

class ZConnectModel {
  final List<String> comments;
  final String title;
  final String authorName;
  final String blogUrl;
  final DateTime uploadedAt;
  final List<String> likes;
  String blogContent;
  String id;
  final String uid;
  ZConnectModel({
    required this.comments,
    required this.title,
    required this.likes,
    required this.authorName,
    required this.blogUrl,
    required this.uploadedAt,
    required this.uid,
    this.id = "",
    this.blogContent = "",
  });

  ZConnectModel copyWith(
      {String? title,
      String? authorName,
      String? blogUrl,
      DateTime? uploadedAt,
      String? blogContent,
      String? uid,
      List<String>? likes,
      List<String>? comments,
      String? id}) {
    return ZConnectModel(
        id: id ?? this.id,
        comments: comments ?? this.comments,
        likes: likes ?? this.likes,
        title: title ?? this.title,
        authorName: authorName ?? this.authorName,
        blogUrl: blogUrl ?? this.blogUrl,
        uploadedAt: uploadedAt ?? this.uploadedAt,
        uid: uid ?? this.uid,
        blogContent: blogContent ?? this.blogContent);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "uid": uid,
      "likes": likes,
      "comments": comments,
      'title': title,
      'authorName': authorName,
      'blogUrl': blogUrl,
      'uploadedAt': uploadedAt.millisecondsSinceEpoch,
    };
  }

  static Future<ZConnectModel> fromMap(Map<String, dynamic> map) async {
    ZConnectModel zconnectModel = ZConnectModel(
      id: map["\$id"] as String,
      comments: map["comments"].cast<String>(),
      likes: map["likes"].cast<String>(),
      uid: map["uid"] as String,
      title: map['title'] as String,
      authorName: map['authorName'] as String,
      blogUrl: map['blogUrl'] as String,
      uploadedAt: DateTime.fromMillisecondsSinceEpoch(map['uploadedAt'] as int),
    );
    zconnectModel.blogContent = await getBlogContent(zconnectModel.blogUrl);
    return zconnectModel;
  }

  @override
  String toString() {
    return 'ZConnectModel(title: $title, authorName: $authorName, blogUrl: $blogUrl, uploadedAt: $uploadedAt  ,likes :$likes , comments:$comments)';
  }

  @override
  bool operator ==(covariant ZConnectModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.authorName == authorName &&
        other.blogUrl == blogUrl &&
        other.uploadedAt == uploadedAt;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        authorName.hashCode ^
        blogUrl.hashCode ^
        uploadedAt.hashCode;
  }
}
