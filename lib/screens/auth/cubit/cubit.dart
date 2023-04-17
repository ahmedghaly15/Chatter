import 'package:chat_app/cubit/cubit.dart';
import 'package:chat_app/screens/auth/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/user_model.dart';
import '/network/local/cache_helper.dart';

enum AuthMode { signIn, signUp }

//==================== Auth Screen Cubit ====================
class AuthScreenCubit extends Cubit<AuthScreenStates> {
  AuthScreenCubit() : super(AuthScreenInitialState());

  //============ Getting An Object Of The Cubit ============
  static AuthScreenCubit getObject(context) => BlocProvider.of(context);

  //============ For Signing In A User ============
  void userSignIn({
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(SignInLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(SignInSuccessState(value.user!.uid));
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      ChatterAppCubit.getObject(context).getUserData(value.user!.uid);
    }).catchError((error) {
      if (error is FirebaseAuthException)
        emit(SignInErrorState(error.code.toString()));
    });
  }

  //============ For Signing Up A User ============
  void userSignUp({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) {
    emit(SignUpLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      firestoreCreateUSer(
        name: username,
        email: email,
        uId: value.user!.uid,
      );

      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      ChatterAppCubit.getObject(context).getUserData(value.user!.uid);
    }).catchError((error) {
      print(error.toString());
      if (error is FirebaseAuthException)
        emit(SignUpErrorState(error.code.toString()));
    });
  }

  void firestoreCreateUSer({
    required String name,
    required String email,
    required String uId,
  }) {
    UserModel userModel = UserModel(
      name: name,
      email: email,
      uId: uId,
      image:
          'https://img.freepik.com/free-icon/user_318-159711.jpg?size=626&ext=jpg&ga=GA1.2.825316313.1674289475&semt=ais',
      about: 'I am a chatter',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toJson())
        .then((value) {
      emit(CreateUserSuccessState());
      emit(SignUpSuccessState(uId));
    }).catchError((error) {
      print(error.toString());
      CreateUserErrorState(error.toString());
    });
  }
}
