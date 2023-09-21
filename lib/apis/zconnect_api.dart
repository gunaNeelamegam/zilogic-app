import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:zilogic/constants/appwrite_constants.dart';
import 'package:zilogic/core/core.dart';
// ignore: library_prefixes
import 'dart:io' as IO;
import 'package:zilogic/core/providers.dart';
import 'package:zilogic/models/zconnect_model.dart';

// providers
final ZConnectApiProvider = Provider((ref) {
  return ZconnectAPI(
    db: ref.watch(appwriteDatabaseProvider),
    storage: ref.watch(appwriteStorageProvider),
    realtime: Realtime(ref.watch(appwriteClientProvider)),
  );
});

abstract class IZconnectApi {
  FutureEither<Document> uploadBlog(ZConnectModel zConnectModel);
  Future<bool> deleteBlog(final String id);
  Future<List<Document>> getAllBlogs();
  Future<bool> deleteAllBlog();
  Stream<RealtimeMessage> getLatestBlog();
  Future<File> storeToBlogBucket(final IO.File blogFile);
  FutureEither<Document> likeBlog(ZConnectModel blog);
}

class ZconnectAPI extends IZconnectApi {
  final Databases _db;
  final Storage _storage;
  final Realtime _realtime;
  ZconnectAPI(
      {required Databases db,
      required Storage storage,
      required Realtime realtime})
      : _storage = storage,
        _realtime = realtime,
        _db = db;

  @override
  Future<bool> deleteAllBlog() async {
    try {
      final zconnectedBlogs = await _db.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.zconnectCollection);
      zconnectedBlogs.documents.forEach((blog) async {
        await _db.deleteDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.zconnectCollection,
            documentId: blog.$id);
      });
      return true;
    } on AppwriteException catch (error, stackTrace) {
      debugPrint(
          "Exception Inside the Appwrite  ${error.toString()} , StackTrace ${stackTrace.toString()}");
      return false;
    } catch (error, stackTrace) {
      debugPrint(
          "Exception Inside the Appwrite  ${error.toString()} , StackTrace ${stackTrace.toString()}");
      return false;
    }
  }

  @override
  Future<bool> deleteBlog(String id) async {
    try {
      await _db.deleteDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.zconnectCollection,
          documentId: id);
      return true;
    } on AppwriteException catch (error, _) {
      return false;
    } catch (error, _) {
      return false;
    }
  }

  @override
  Future<List<Document>> getAllBlogs() async {
    final allBlogs = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.zconnectCollection);
    return allBlogs.documents;
  }

  @override
  Future<File> storeToBlogBucket(final IO.File blogFile) async {
    final uploadBlogFile = await _storage.createFile(
      bucketId: AppwriteConstants.blogBucket,
      fileId: ID.unique(),
      file: InputFile.fromPath(
          path: blogFile.path, filename: blogFile.path.split(".")[-2]),
    );
    return uploadBlogFile;
  }

  @override
  FutureEither<Document> uploadBlog(ZConnectModel zConnectModel) async {
    try {
      final document = await _db.createDocument(
          collectionId: AppwriteConstants.zconnectCollection,
          databaseId: AppwriteConstants.databaseId,
          data: zConnectModel.toMap(),
          documentId: ID.unique());
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestBlog() {
    return _realtime.subscribe([
      "databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.zconnectCollection}.documents.create"
    ]).stream;
  }

  @override
  FutureEither<Document> likeBlog(ZConnectModel blog) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.zconnectCollection,
        documentId: blog.id,
        data: {
          "likes": blog.likes,
        },
      );
      return right(document);
    } on AppwriteException catch (error, stackTrace) {
      return left(Failure(error.message ?? error.toString(), stackTrace));
    } catch (error, stackTrace) {
      return left(Failure(error.toString(), stackTrace));
    }
  }
}
