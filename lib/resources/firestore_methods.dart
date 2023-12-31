import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:church_and/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import '../models/Post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Upload Post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
  ) async {
    String response = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        datePublished: Timestamp.now(),
        postId: postId,
        postUrl: photoUrl,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      response = "Post is successfully created";
    } catch (err) {
      response = err.toString();
    }
    return response;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> postComments(
      String postId, String text, String uid, String name) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'name': name,
            'uid': uid,
            'text': text,
            'commentId': commentId,
            'datePublished': Timestamp.now()
          },
        );
      } else {
        if (kDebugMode) {
          print('Text Is empty');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }
}
