import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final Timestamp createdOn;
  final Timestamp updatedOn;
  final Timestamp lastSeen;
  final String permission;

  const User(
      {required this.username,
      required this.uid,
      required this.email,
      required this.createdOn,
      required this.lastSeen,
      required this.updatedOn,
      required this.permission});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        createdOn: snapshot['createdOn'],
        lastSeen: snapshot['lastSeen'],
        updatedOn: snapshot['updatedOn'],
        permission: snapshot['permission']);
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        'createdOn': createdOn,
        'lastSeen': lastSeen,
        'updatedOn': updatedOn,
        'permission': permission
      };
}
