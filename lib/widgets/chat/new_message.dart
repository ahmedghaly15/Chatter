import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '/theme.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  // New Message TextField Controller
  final TextEditingController _textController = TextEditingController();

  // The Message User Enters
  String _enteredMsg = '';

  // ============ Send Messages Function ============
  _sendMessage() async {
    // Close The Keyboard When The Screen Is Tapped
    FocusScope.of(context).unfocus();

    // get current user
    final user = FirebaseAuth.instance.currentUser;

    // get the current user's document id in firebase
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    // add new message to chat collection in firebase
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMsg,
      'createdAt': Timestamp.now(),
      'username': userData['username'],
      'userId': user.uid,
      'userImg': userData['userImgUrl'],
    });
    _textController.clear();
    setState(() {
      // reset to empty value after sending a message
      _enteredMsg = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: Row(
                children: <Widget>[
                  // ============== Emoji Button ==============
                  IconButton(
                    icon: const Icon(
                      Icons.emoji_emotions_rounded,
                      color: primaryClr,
                      size: 25,
                    ),
                    onPressed: () {},
                  ),
                  // ============== Type A New Message TextField ==============
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      autocorrect: true,
                      enableSuggestions: true,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: bodyStyle3,
                        suffixIconColor: primaryClr,
                        contentPadding: const EdgeInsets.only(left: 10.0),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _enteredMsg = val;
                        });
                      },
                    ),
                  ),
                  // ============== Pick Image From Gallery Button ==============
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image_rounded,
                      color: primaryClr,
                      size: 25,
                    ),
                  ),
                  // ============== Pick Image From Camera Button ==============
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: primaryClr,
                      size: 25,
                    ),
                  ),
                  // for adding some space
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                ],
              ),
            ),
          ),
          // ============== Send New Message Button ==============
          IconButton(
            onPressed: _enteredMsg.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
            disabledColor: Colors.grey,
            iconSize: 30,
            color: primaryClr,
          ),
        ],
      ),
    );
  }
}
