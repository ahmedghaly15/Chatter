import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/models/chat_user.dart';
import '/screens/chat_screen.dart';
import '/theme.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Get.isDarkMode ? darkHeaderClr : Colors.white,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025, vertical: 4),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // ============== Navigating To ChatScreen ==============
          Get.to(
            () => ChatScreen(user: widget.user),
            transition: Transition.leftToRight,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: ListTile(
            // ============== User Profile Picture ==============
            leading: widget.user.userImgUrl == null
                ? const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.userImgUrl!),
                    radius: 28,
                  ),

            // ============== Username ==============
            title: Text(widget.user.username!),

            // ============== User's About ==============
            subtitle: Text(
              widget.user.about!,
              maxLines: 1,
            ),

            // ============== Online Indicator ==============
            trailing: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: primaryClr,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
