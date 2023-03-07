import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/models/chat_user.dart';
import '/theme.dart';
import '/widgets/chat/message.dart';
import '/widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        // Close The Keyboard When The Screen Is Tapped
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Get.isDarkMode ? Colors.white12 : Colors.white70,
          // ================= Chat Screen App Bar =================
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.background,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor:
                  Get.isDarkMode ? darkGreyClr : Colors.white,
              statusBarColor: Get.isDarkMode ? darkGreyClr : Colors.white,
            ),
            elevation: 1,
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          // ================= Chat Screen Content =================
          body: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              const Expanded(
                child: Messages(),
              ),
              const NewMessage(),
            ],
          ),
        ),
      ),
    );
  }

// ============================= For Building A Customized AppBar =============================
  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: <Widget>[
          // =============== Back Button ===============
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
              size: 25,
            ),
            onPressed: () => Get.back(),
          ),
          // =============== User Profile Picture ===============
          ClipRRect(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.height * 0.03,
            ),
            child: CachedNetworkImage(
              imageUrl: widget.user.userImgUrl!,
              width: MediaQuery.of(context).size.height * 0.05,
              height: MediaQuery.of(context).size.height * 0.05,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const CircularProgressIndicator(color: primaryClr),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          // =============== For Adding Some Space ===============
          const SizedBox(width: 10),
          // =============== Username & Lasr Seen ===============
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Username
              Text(
                widget.user.username!,
                style: bodyStyle1.copyWith(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              // =============== For Adding Some Space ===============
              const SizedBox(height: 2),
              // Last Seen
              Text("Last seen not available",
                  style: bodyStyle1.copyWith(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
