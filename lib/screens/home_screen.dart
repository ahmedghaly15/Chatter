import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/apis/apis.dart';
import '/models/chat_user.dart';
import '/screens/profile_screen.dart';
import '/services/theme_services.dart';
import '/theme.dart';
import '/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // =============== For Storing All The Users ===============
  List<ChatUser> _list = [];

  // =============== For Storing Searched Items ===============
  final List<ChatUser> _searchList = [];

  // =============== For Storing Searched Status ===============
  bool _isSearching = false;

  // =============== Getting Current User Using SharedPreferences ===============
  getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('mail')!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Get The Current User Info
    Apis.geteSelfInfo();
    // Get The Current User Email
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Close The Keyboard When The Screen Is Tapped
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        /*
        if search form is on & back button is pressed, then search form is closed.
        or else close the current screen (home screen) when the back button is clicked. 
        note: this widget is only applicable to Scaffold()
         */
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: context.theme.colorScheme.background,
          // =================== Home Screen App Bar ======================
          appBar: AppBar(
            backgroundColor: context.theme.colorScheme.background,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor:
                  Get.isDarkMode ? darkGreyClr : Colors.white,
              statusBarColor: Get.isDarkMode ? darkGreyClr : Colors.white,
            ),
            title: _isSearching ? buildSearchFormField() : const Text("Chats"),
            centerTitle: true,
            elevation: 0,
            titleTextStyle: headingStyle,
            // ================= Switching Between (Light / Dark) Modes =================
            leading: IconButton(
              onPressed: () async {
                ThemeServices().switchTheme();
              },
              icon: Icon(
                Get.isDarkMode
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_round_outlined,
                size: 28,
                color: Get.isDarkMode ? Colors.white : darkGreyClr,
              ),
            ),
            actions: <Widget>[
              // =============== Search Button ===============
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(
                    _isSearching ? Icons.cancel : Icons.search_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 25,
                  )),
              // =============== Profile Screen Button ===============
              IconButton(
                  onPressed: () {
                    Get.to(
                      () => ProfileScreen(
                        user: Apis.me,
                      ),
                      transition: Transition.leftToRight,
                    );
                  },
                  icon: Icon(
                    Icons.person_rounded,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 25,
                  )),
            ],
          ),
          // =================== Home Screen Body ======================
          body: StreamBuilder(
            stream: Apis.getAllUsers(),
            builder: (context, snapShot) {
              switch (snapShot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                      child: CircularProgressIndicator(
                    color: primaryClr,
                  ));

                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapShot.data?.docs;

                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
                        });
                  } else {
                    return Center(
                      child: Text(
                        "No connections found!",
                        style: subHaedingStyle,
                      ),
                    );
                  }
              }
            },
          ),
          // =================== Floating Action Button ======================
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: primaryClr,
              child: const Icon(
                Icons.add_comment_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

// ============================= For Building A Search Form =============================
  Padding buildSearchFormField() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: TextFormField(
          autofocus: true,
          enableSuggestions: true,
          keyboardType: TextInputType.name,
          style: subTitleStyle,
          cursorColor: Colors.grey,
          onChanged: (val) {
            // Search Form Logic
            _searchList.clear();
            for (var i in _list) {
              if (i.username!.toLowerCase().contains(val.toLowerCase()) ||
                  i.userMail!.toLowerCase().contains(val.toLowerCase())) {
                _searchList.add(i);
                setState(() {
                  _searchList;
                });
              }
            }
          },
          decoration: InputDecoration(
            hintText: "Name, Email...",
            hintStyle: bodyStyle3.copyWith(
              color: Get.isDarkMode ? Colors.grey[500] : Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
}
