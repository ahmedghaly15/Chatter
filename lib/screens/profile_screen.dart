import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/apis/apis.dart';
import '/models/chat_user.dart';
import '/theme.dart';
import '/widgets/helpers/functions_helper.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Close The Keyboard When The Screen Is Tapped
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        // ================= Profile Screen App Bar =================
        appBar: AppBar(
          backgroundColor: context.theme.colorScheme.background,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor:
                Get.isDarkMode ? darkGreyClr : Colors.white,
            statusBarColor: Get.isDarkMode ? darkGreyClr : Colors.white,
          ),
          title: const Text("Profile"),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: headingStyle,
          // Go Back
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
              size: 25,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        // ================= Profile Screen Content =================
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                // user profile picture
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        // =============== User Profile Picture ===============
                        _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.1,
                                ),
                                child: Image.file(
                                  File(_image!),
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.1,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.user.userImgUrl!,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(
                                          color: primaryClr),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                        // =============== Change Profile Picture ===============
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            onPressed: showBottomSheet,
                            elevation: 1,
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(
                              Icons.edit_rounded,
                              color: primaryClr,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // for adding some space
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                // =============== User Email ===============
                Text(widget.user.userMail!, style: subHaedingStyle),
                // for adding some space
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // =============== User Name TextField ===============
                Helper.buildForm(
                  user: widget.user,
                  label: "Name",
                  hint: "Name",
                  capitalize: TextCapitalization.words,
                  prefixIcon: const Icon(
                    Icons.person_rounded,
                    color: primaryClr,
                    size: 28,
                  ),
                  // saving user name
                  saving: (val) => Apis.me.username = val,
                  // validating user name
                  validating: (val) {
                    if (val != null && val.isNotEmpty) {
                      return null;
                    }
                    return "Required Field";
                  },
                ),
                // for adding some space
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                // =============== User About TextField ===============
                Helper.buildForm(
                  user: widget.user,
                  label: "About",
                  hint: "About",
                  capitalize: TextCapitalization.sentences,
                  prefixIcon: const Icon(
                    Icons.info_rounded,
                    color: primaryClr,
                    size: 28,
                  ),
                  saving: (val) => Apis.me.about = val,
                  validating: (val) {
                    if (val != null && val.isNotEmpty) {
                      return null;
                    }
                    return "Required Field";
                  },
                ),
                // for adding some space
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // =============== Update User Info ===============
                ElevatedButton.icon(
                  onPressed: updateButtonOnTap,
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                  label: Text(
                    "UPDATE",
                    style: titleBodyStyle,
                    textAlign: TextAlign.center,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryClr),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                          horizontal: 35.0, vertical: 15.0),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // =============== Log out Button Using SharedPreferences ===============
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              // sign out from the app
              prefs.clear();
              // go to Auth Screen
              Get.offAll(() => const AuthScreen(),
                  transition: Transition.leftToRight);
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 20,
            ),
            label: Text("Log out", style: titleBodyStyle),
          ),
        ),
      ),
    );
  }

// ================= Updating User Info Function =================
  void updateButtonOnTap() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // update user name & about
      Apis.updateUserInfo().then((value) {
        Helper.buildSnackBar(
          title: "Update",
          message: "Profile updated successfully!",
        );
      });
    }
  }

// ======================== Build Bottom Sheet Function =============================
// for picking a profile picture for user.
  void showBottomSheet() {
    Get.bottomSheet(
      ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.03,
          bottom: MediaQuery.of(context).size.height * 0.05,
        ),
        children: <Widget>[
          Text(
            "Pick profile picture",
            style: titleStyle.copyWith(letterSpacing: 1),
            textAlign: TextAlign.center,
          ),
          // ============ Buttons ============
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // ============ Pick From Gallery ============
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  // ============ Pick An Image ============
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _image = image.path;
                    });
                    // ============ Updating User Profile Picture ============
                    Apis.updateProfilePic(File(_image!));
                    // for hiding bottom sheet
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
                  shape: const CircleBorder(),
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.3,
                    MediaQuery.of(context).size.height * 0.15,
                  ),
                ),
                child: Image.asset('assets/images/add_image.png'),
              ),
              // ============ Pick From Camera ============
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  // pick an image
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _image = image.path;
                    });
                    // ============ Updating User Profile Picture ============
                    Apis.updateProfilePic(File(_image!));
                    // for hiding bottom sheet
                    Get.back();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
                  shape: const CircleBorder(),
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.3,
                    MediaQuery.of(context).size.height * 0.15,
                  ),
                ),
                child: Image.asset('assets/images/camera.png'),
              ),
            ],
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
    );
  }
}
