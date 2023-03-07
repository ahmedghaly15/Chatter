import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, AsyncSnapshot snapShot) {
          // ============ If Data is Waiting or There's no Data ============
          if (snapShot.connectionState == ConnectionState.waiting ||
              snapShot.connectionState == ConnectionState.none) {
            return const SizedBox();
          }
          // ============ If Some Or All Data Is Loaded ============
          final docs = snapShot.data!.docs;
          final user = FirebaseAuth.instance.currentUser;
          return ListView.builder(
            reverse: true,
            itemCount: docs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              key: ValueKey(docs[index].id),
              message: docs[index]['text'],
              username: docs[index]['username'],
              userImg: docs[index]['userImg'],
              isMe: docs[index]['userId'] == user!.uid,
            ),
          );
        },
      ),
    );
  }
}
