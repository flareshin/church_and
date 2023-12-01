import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:church_and/resources/auth_methods.dart';

import '../models/User.dart';

class UserProvider {
  User? _user = User(
      username: "",
      uid: "uid",
      email: "email",
      createdOn: Timestamp.now(),
      lastSeen: Timestamp.now(),
      updatedOn: Timestamp.now(),
      permission: "users");
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
  }
}
