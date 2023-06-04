import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '/cubit/cubit.dart';
import '/cubit/states.dart';
import '/models/user_model.dart';
import '/shared/components/default_button.dart';
import '/shared/components/input_field.dart';
import '/shared/constants.dart';
import '../services/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatterAppCubit, ChatterAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController aboutController = TextEditingController();
        UserModel userModel = ChatterAppCubit.getObject(context).model!;
        nameController.text = userModel.name!;
        aboutController.text = userModel.about!;

        ChatterAppCubit cubit = ChatterAppCubit.getObject(context);
        File? profileImage = cubit.profileImage;

        return Scaffold(
          backgroundColor: context.theme.colorScheme.background,
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      radius: 54,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: (profileImage == null
                            ? NetworkImage(userModel.image!)
                            : FileImage(profileImage)) as ImageProvider,
                      ),
                    ),
                    IconButton(
                      onPressed: () => buildBottomSheet(
                        type: "Profile",
                        context: context,
                        onPressedCamera: () => cubit.getProfileImage(
                          source: ImageSource.camera,
                        ),
                        onPressedGallery: () => cubit.getProfileImage(
                          source: ImageSource.gallery,
                        ),
                      ),
                      icon: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera_alt,
                          color: primaryClr,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                // =============== User Email ===============
                Text(userModel.email!, style: subHaedingStyle),

                // for adding some space
                if (cubit.profileImage != null)
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                if (cubit.profileImage != null)
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        DefaultButton(
                          buttonText: "Upload Profile Image",
                          onPressed: () => cubit.uploadProfileImage(
                            context: context,
                            name: nameController.text,
                            about: aboutController.text,
                          ),
                          width: 15,
                          height: 10,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (state is UploadingProfileImageLoadingState)
                          const SizedBox(height: 5),
                        if (state is UploadingProfileImageLoadingState)
                          const SizedBox(
                            width: 150,
                            child: LinearProgressIndicator(
                              color: primaryClr,
                            ),
                          ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Column(
                    children: <Widget>[
                      InputField(
                        hint: "Name",
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        validating: (val) {
                          if (val!.isEmpty) {
                            return "Name can't be blank!";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person),
                        obsecure: false,
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        hint: "About",
                        controller: aboutController,
                        textCapitalization: TextCapitalization.none,
                        validating: (val) {
                          if (val!.isEmpty) {
                            return "About can't be blank!";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.info),
                        obsecure: false,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                DefaultButton(
                  buttonText: "UPDATE",
                  onPressed: () {
                    cubit.updateUser(
                      name: nameController.text,
                      about: aboutController.text,
                    );
                  },
                  height: 13,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () => signOut(context),
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: Text("Log out", style: titleBodyStyle),
            ),
          ),
        );
      },
    );
  }
}
