import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';
import '/apis/apis.dart';
import '/screens/home_screen.dart';
import '/widgets/helpers/functions_helper.dart';
import '/widgets/input_field.dart';
import '/widgets/pickers/user_image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => AuthScreenState();
}

enum AuthMode { signUp, login }

class AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode authMode = AuthMode.login;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool passVisiblity = true;
  bool confirmPassVisiblity = true;
  final Map<String, String> _authData = {
    'email': '',
    'pass': '',
    'username': '',
  };

// ============================= For Choosing The Profile Picture =============================
  File? _userImage;
  void _pickedImage(File pickedImage) {
    _userImage = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Close The Keyboard When The Screen Is Tapped
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Get.isDarkMode ? darkHeaderClr : backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ======================== Form =============================
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: double.infinity,
                  height: authMode == AuthMode.login
                      ? MediaQuery.of(context).size.height * 0.82
                      : MediaQuery.of(context).size.height * 0.88,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Get.isDarkMode ? darkGreyClr : Colors.white,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // ======================== User Image =============================
                        if (authMode == AuthMode.signUp)
                          UserImagePicker(_pickedImage),
                        const SizedBox(height: 20),
                        // ======================== Email TextFormField =============================
                        InputField(
                          key: const ValueKey("email"),
                          autoCorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.none,
                          hint: "Enter your email",
                          obsecure: false,
                          controller: _emailController,
                          validating: (val) {
                            if (val!.isEmpty || !val.contains('@')) {
                              return "Invalid E-mail";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          saving: (val) {
                            _authData['email'] = val!;
                          },
                        ),
                        const SizedBox(height: 20),
                        // ======================== Username TextFormField =============================
                        if (authMode == AuthMode.signUp)
                          InputField(
                            key: const ValueKey("username"),
                            autoCorrect: true,
                            enableSuggestions: false,
                            textCapitalization: TextCapitalization.words,
                            hint: "Enter your username",
                            obsecure: false,
                            controller: _usernameController,
                            validating: (val) {
                              if (val!.isEmpty) {
                                return "Invalid Username";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            saving: (val) {
                              _authData['username'] = val!;
                            },
                          ),
                        const SizedBox(height: 20),
                        // ======================== Password TextFormField =============================
                        InputField(
                          autoCorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.none,
                          key: const ValueKey("Password"),
                          hint: "Enter your password",
                          obsecure: passVisiblity,
                          icon: IconButton(
                            onPressed: () {
                              setState(() {
                                passVisiblity = !passVisiblity;
                              });
                            },
                            icon: Icon(passVisiblity
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                          ),
                          controller: _passController,
                          validating: (val) {
                            if (val!.isEmpty || val.length < 5) {
                              return "Password is too short";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          saving: (val) {
                            _authData['pass'] = val!;
                          },
                        ),
                        const SizedBox(height: 20),
                        // ======================== Confirm Password TextFormField =============================
                        if (authMode == AuthMode.signUp)
                          InputField(
                            key: const ValueKey("Confirmation"),
                            autoCorrect: false,
                            enableSuggestions: false,
                            textCapitalization: TextCapitalization.none,
                            hint: "Confirm your password",
                            obsecure: confirmPassVisiblity,
                            icon: IconButton(
                              onPressed: () {
                                setState(() {
                                  confirmPassVisiblity = !confirmPassVisiblity;
                                });
                              },
                              icon: Icon(confirmPassVisiblity
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded),
                            ),
                            controller: _confirmPassController,
                            validating: authMode == AuthMode.signUp
                                ? (val) {
                                    if (val!.isEmpty ||
                                        val != _passController.text) {
                                      return "Password don't match";
                                    }
                                    return null;
                                  }
                                : null,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        SizedBox(height: authMode == AuthMode.login ? 30 : 40),
                        // ======================== (Log in - Sign up ) Button =============================
                        ElevatedButton.icon(
                          onPressed: _signInOrSignup,
                          icon: const Icon(
                            Icons.login_rounded,
                            size: 22,
                            color: Colors.white,
                          ),
                          label: Text(
                            authMode == AuthMode.login ? 'Log in' : 'Sign up',
                            textAlign: TextAlign.center,
                            style: headingStyle.copyWith(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(primaryClr),
                            elevation: MaterialStateProperty.all(10.0),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                horizontal: 80.0,
                                vertical: 18.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              authMode == AuthMode.login
                                  ? "Don't have an account?"
                                  : "Already have an account?",
                              style: subTitleStyle.copyWith(fontSize: 15),
                            ),
                            // ======================== (Sign in / Sign up) Button =============================
                            TextButton(
                              onPressed: _switchAuthMode,
                              child: Text(
                                authMode == AuthMode.login
                                    ? "Sign up"
                                    : "Sign in",
                                style: subTitleStyle.copyWith(
                                  color: primaryClr,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// ======================== Switch Between (Login / Log out) Modes Function =============================
  void _switchAuthMode() {
    if (authMode == AuthMode.login) {
      setState(() {
        authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        authMode = AuthMode.login;
      });
    }
  }

// ======================== Submit (Sign in / Sign up) Info Function =============================
  void _signInOrSignup() async {
    UserCredential authResult;
    FocusScope.of(context).unfocus();
    // =============== Validating User Info ===============
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    // Log in Mode
    if (authMode == AuthMode.login) {
      try {
        // =============== Sign in Using Firebase ===============
        authResult = await Apis.auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text,
        );
        // Navigate To Home Screen
        Get.offAll(() => const HomeScreen(), transition: Transition.fadeIn);
      }
      // =============== Handling Errors Of Signing In Mode ===============
      on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found') {
          Helper.buildSnackBar(
            title: "Warning",
            message: "No user found for that email",
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 30,
            ),
          );
        } else if (error.code == 'wrong-password') {
          Helper.buildSnackBar(
              message: "Wrong Password",
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 30,
              ),
              title: "Warning");
        }
      }
    }
    // Sign up Mode
    else if (authMode == AuthMode.signUp) {
      try {
        // =============== Handling Errors Of The Profile Picture ===============
        if (_userImage == null) {
          Helper.buildSnackBar(
            title: "Warning",
            message: "Please pick an image",
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 30,
            ),
          );
          return;
        }
        // =============== Creating A New User Using Firebase ===============
        if (_passController.text == _confirmPassController.text) {
          authResult = await Apis.auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passController.text,
          );

          // =============== Uploading Profile Picture To Firebase ===============
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_image')
              .child('${authResult.user!.uid}.jpg');
          await ref.putFile(_userImage!);
          final imgUrl = await ref.getDownloadURL();

          // =============== Store User Data In Firebase ===============
          Apis.createUser(
            _passController,
            _emailController,
            _usernameController,
            imgUrl,
            authResult.user!.uid,
          );
          // Navigate To Home Screen
          Get.offAll(() => const HomeScreen(), transition: Transition.fadeIn);
        }
      }
      // =============== Handling Errors Of Signing Up Mode ===============
      on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Helper.buildSnackBar(
            title: "Warning",
            message: "Password is too weak",
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 30,
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          Helper.buildSnackBar(
            title: "Warning",
            message: "Account already exists",
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 30,
            ),
          );
        }
      }
    }
    // =============== Store User Email Using SharedPreferences ===============
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mail', _authData['email']!);
  }
}
