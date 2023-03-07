import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/theme.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    this.newKey,
    required this.message,
    required this.username,
    required this.userImg,
    required this.isMe,
  });

  final Key? newKey;
  final String message;
  final String username;
  final String userImg;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: isMe ? primaryClr : Colors.white54,
                    // ============ Make Curved Message Borders ============
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomRight: isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(20),
                      bottomLeft: isMe
                          ? const Radius.circular(20)
                          : const Radius.circular(0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.45,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.height * 0.015,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                    vertical: MediaQuery.of(context).size.height * 0.009,
                  ),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        username,
                        style: titleBodyStyle.copyWith(
                          color: Get.isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        message,
                        style: bodyStyle1,
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // =========== User Profile Picture ============
          Positioned(
            top: -5,
            left: isMe ? null : MediaQuery.of(context).size.width * 0.4,
            right: isMe ? MediaQuery.of(context).size.width * 0.4 : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.1,
              ),
              child: CachedNetworkImage(
                imageUrl: userImg,
                width: MediaQuery.of(context).size.height * 0.05,
                height: MediaQuery.of(context).size.height * 0.05,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(color: primaryClr),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
