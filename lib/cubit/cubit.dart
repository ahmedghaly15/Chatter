import 'dart:io';

import 'package:chat_app/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';
import '../network/local/cache_helper.dart';
import '../shared/constants.dart';

class ChatterAppCubit extends Cubit<ChatterAppStates> {
  ChatterAppCubit() : super(InitialState());

  static ChatterAppCubit getObject(context) => BlocProvider.of(context);

  UserModel? model;

  //============ Getting The Current User Data ============
  void getUserData(String? uId) {
    emit(GetUserLoadingState());

    // Storing The Current User Id
    uId = CacheHelper.getStringData(key: 'uId');

    // Getting Stored Data From Firebase
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      // Assign The Data
      model = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserErrorState(error.toString()));
    });
  }

  File? profileImage;
  ImagePicker picker = ImagePicker();

  //============ Getting The User's Profile Image ============
  Future<void> getProfileImage({required ImageSource source}) async {
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      print("No image has been selected");
      emit(ProfileImagePickedErrorState());
    }
  }

  //============ Uploading The User's Profile Image To Firebase Storage ============
  void uploadProfileImage({
    required String name,
    required String about,
    required BuildContext context,
  }) {
    emit(UploadingProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(UploadProfileImageSuccessState());
        updateUser(
          name: name,
          about: about,
          image: value,
        );
        buildSnackBar(
          message: "Profile Image Updated Successfully",
          state: SnackBarStates.success,
          context: context,
        );
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  //============ Update The Current User's Data ============
  void updateUser({
    required String name,
    required String about,
    String? image,
  }) {
    UserModel userModel = UserModel(
      name: name,
      about: about,
      image: image ?? model!.image,
      email: model!.email,
      uId: model!.uId,
    );
    // Update The Data Stored in Firebase
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(userModel.toJson())
        .then((value) {
      getUserData(uId);
    }).catchError((error) {
      emit(UserUpdateErrorState());
    });
  }

  List<UserModel> users = [];

  //============ Getting All Users ============
  void getAllUsers() {
    users = [];
    if (users.isEmpty)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != model!.uId)
            users.add(UserModel.fromJson(element.data()));
        }
        emit(GetAllUserSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(GetAllUserErrorState(error.toString()));
      });
  }

  //============ Sending A New Message ============
  void sendMessage({
    required String receiverId,
    required String receiverName,
    required String date,
    required String time,
    String? text,
    Map<String, dynamic>? messageImage,
  }) {
    MessageModel messageModel = MessageModel(
      senderId: model!.uId,
      senderName: model!.name,
      receiverId: receiverId,
      receiverName: receiverName,
      time: time,
      date: date,
      messageText: text ?? '',
      messageImage: messageImage ?? {},
      dateTime: Timestamp.now(),
    );

    // Setting up sender Chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    // Setting up receiver Chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(model!.uId)
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  File? messageImage;

  //============ Getting A Message Image ============
  Future<void> getMessageImage({required ImageSource source}) async {
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      messageImage = File(pickedImage.path);
      emit(MessageImagePickedSuccessState());
    } else {
      print("No image selected");
      emit(MessageImagePickedErrorState());
    }
  }

  //============ Uploading A Message Image To Firebase ============
  void uploadMessageImage({
    String? text,
    required String receiverId,
    required String receiverName,
    required String date,
    required String time,
  }) {
    emit(UploadMessageImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('messages/${Uri.file(messageImage!.path).pathSegments.last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
          receiverId: receiverId,
          receiverName: receiverName,
          date: date,
          time: time,
          messageImage: {
            'image': value,
            'height': 150,
          },
          text: text,
        );
        emit(UploadMessageImageSuccessState());
      }).catchError((error) {
        emit(UploadMessageImageErrorState());
      });
    }).catchError((error) {
      emit(UploadMessageImageErrorState());
    });
  }

  //============ Removing A Message Image While Sending A Message ============
  void removeMessageImage() {
    messageImage = null;
    emit(RemovedMessageImageSuccessState());
  }

  List<MessageModel> messages = [];

  //============ Getting All Messages ============
  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy(
          'dateTime',
          descending: true,
        )
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(GetMessagesSuccessState());
    });
  }

  List<UserModel> searchList = [];
  bool isSearching = false;

  //============ Inverting The Search State ============
  void invertIsSearching() {
    isSearching = !isSearching;
    emit(InvertIsSearchingSuccessState());
  }

  //============ Rebuilding The Search List ============
  void rebuildSearchList(List<UserModel> list) {
    emit(SearchListUpdateSuccessState(list));
  }

  //============ When The Search Field Text Changes ============
  void onChangeText(value, text) {
    text = value;
    emit(OnChangeTextSuccessState());
  }
}
