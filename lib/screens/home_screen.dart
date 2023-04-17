import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '/cubit/cubit.dart';
import '/cubit/states.dart';
import '/models/user_model.dart';
import '/screens/profile_screen.dart';
import '/services/theme_services.dart';
import '/shared/constants.dart';
import '/theme.dart';
import 'chat_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        ChatterAppCubit.getObject(context).getAllUsers();
        return BlocConsumer<ChatterAppCubit, ChatterAppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            ChatterAppCubit cubit = ChatterAppCubit.getObject(context);

            return GestureDetector(
              // Close The Keyboard When The Screen Is Tapped
              onTap: () => FocusScope.of(context).unfocus(),
              child: WillPopScope(
                onWillPop: () {
                  if (cubit.isSearching) {
                    cubit.invertIsSearching();
                    return Future.value(false);
                  }
                  return Future.value(true);
                },
                child: Scaffold(
                  backgroundColor: context.theme.colorScheme.background,
                  // =================== Home Screen App Bar ======================
                  appBar: AppBar(
                    backgroundColor: context.theme.colorScheme.background,
                    systemOverlayStyle: SystemUiOverlayStyle(
                      systemNavigationBarColor:
                          Get.isDarkMode ? darkGreyClr : Colors.white,
                      statusBarColor:
                          Get.isDarkMode ? darkGreyClr : Colors.white,
                      statusBarBrightness:
                          Get.isDarkMode ? Brightness.light : Brightness.dark,
                    ),
                    title: cubit.isSearching
                        ? buildSearchField(cubit)
                        : const Text("Chats"),
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
                          cubit.invertIsSearching();
                        },
                        icon: Icon(
                          cubit.isSearching
                              ? Icons.cancel
                              : Icons.search_rounded,
                          color: primaryClr,
                        ),
                      ),
                      // =============== Profile Screen Button ===============
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () => const ProfileScreen(),
                          );
                        },
                        icon: const Icon(
                          Icons.person_rounded,
                          color: primaryClr,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  // =================== Home Screen Body ======================
                  body: ConditionalBuilder(
                    condition: cubit.users.isNotEmpty,
                    builder: (context) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cubit.isSearching
                            ? cubit.searchList.length
                            : cubit.users.length,
                        itemBuilder: (context, index) => buildChatItem(
                          context: context,
                          model: cubit.isSearching
                              ? cubit.searchList[index]
                              : cubit.users[index],
                        ),
                      );
                    },
                    fallback: (contxt) => Center(
                      child: Text(
                        "No connections found!",
                        style: subHaedingStyle,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildChatItem({
    required BuildContext context,
    required UserModel model,
  }) =>
      InkWell(
        onTap: () => navigateTo(context, ChatDetailsScreen(userModel: model)),
        child: Card(
          color: Get.isDarkMode ? darkHeaderClr.withOpacity(0) : Colors.white,
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.025,
            vertical: 4,
          ),
          elevation: 1.5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
            child: ListTile(
              // ============== User Profile Picture ==============
              leading: Hero(
                tag: model.uId!,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(model.image!),
                  radius: 28,
                ),
              ),
              // ============== Username ==============
              title: Text(
                model.name!,
                style: titleStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              // ============== User's Bio ==============
              subtitle: Text(
                model.about!,
                style: caption.copyWith(fontSize: 14),
                maxLines: 1,
              ),
            ),
          ),
        ),
      );

  Widget buildSearchField(ChatterAppCubit cubit) {
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: true,
          enableSuggestions: true,
          keyboardType: TextInputType.name,
          cursorColor: Colors.grey,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Name...",
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
              letterSpacing: 0.5,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: primaryClr,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onChanged: (value) {
            cubit.searchList.clear();
            for (var user in cubit.users) {
              if (user.name!.toLowerCase().contains(value.toLowerCase())) {
                cubit.searchList.add(user);
                cubit.rebuildSearchList(cubit.searchList);
              }
            }
          },
        ),
      ),
    );
  }
}
