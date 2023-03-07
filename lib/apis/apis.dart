import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '/models/chat_user.dart';

class Apis {
  // for firebase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firebase database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storag
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self info
  static late ChatUser me;

  // to get the current user
  static User get user => auth.currentUser!;

// ============================= For Getting Current User Info =============================
  static TextEditingController? _passController;
  static TextEditingController? _emailController;
  static TextEditingController? _usernameController;
  static String? _imgUrl;
  static String? _id;

  static Future<void> geteSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser(
          _passController!,
          _emailController!,
          _usernameController!,
          _imgUrl!,
          _id!,
        ).then((value) => geteSelfInfo());
      }
    });
  }

// ============================= For Creating A New User =============================
  static Future<void> createUser(
    TextEditingController passController,
    TextEditingController emailController,
    TextEditingController usernameController,
    String imgUrl,
    String id,
  ) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      userPass: passController.text,
      userMail: emailController.text,
      about: "Hey, I am using Chatter",
      createdAt: time,
      userImgUrl: imgUrl,
      username: usernameController.text,
      id: id,
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

// ============================= For Getting All Users From Firebase Database =============================
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

// ============================= For Updating User Info =============================
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'username': me.username,
      'about': me.about,
    });
  }

// ============================= For Updating Profile Picture =============================
  static Future<void> updateProfilePic(File file) async {
    // getting image file extension
    final ext = file.path.split('.').last;

    // store image file ref with path
    final ref = storage.ref().child('user_image/${user.uid}.$ext');

    // uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    // uploading image file to firestore database
    me.userImgUrl = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update(
      {'userImgUrl': me.userImgUrl},
    );
  }
}
