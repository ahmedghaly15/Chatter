import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '/network/local/cache_helper.dart';
import '/screens/home_screen.dart';
import '/shared/components/default_button.dart';
import '/shared/components/input_field.dart';
import '/shared/constants.dart';
import '/theme.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode authMode = AuthMode.signIn;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool passVisiblity = true;
  bool confirmPassVisiblity = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthScreenCubit(),
      child: BlocConsumer<AuthScreenCubit, AuthScreenStates>(
        listener: (context, state) {
          //=============== Controlling The States ===============
          if (state is SignInErrorState) {
            if (state.error == 'user-not-found') {
              buildSnackBar(
                message: "No user found for that email",
                state: SnackBarStates.error,
                context: context,
              );
            } else if (state.error == 'wrong-password') {
              buildSnackBar(
                message: "Wrong Password",
                state: SnackBarStates.error,
                context: context,
              );
            }
          }

          if (state is SignUpErrorState) {
            if (state.error == 'weak-password') {
              buildSnackBar(
                message: "Password is too weak",
                state: SnackBarStates.error,
                context: context,
              );
            } else if (state.error == 'email-already-in-use') {
              buildSnackBar(
                message: "Account already exists",
                state: SnackBarStates.error,
                context: context,
              );
            }
          }

          if (state is SignInSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, screen: const HomeScreen());
            });
          }

          if (state is SignUpSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, screen: const HomeScreen());
            });
            buildSnackBar(
              message: "Account Created Successfully",
              state: SnackBarStates.success,
              context: context,
            );
          }

          if (state is CreateUserSuccessState) {
            navigateAndFinish(context, screen: const HomeScreen());
          }
        },
        builder: (context, state) {
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
                        height: authMode == AuthMode.signIn
                            ? MediaQuery.of(context).size.height * 0.6
                            : MediaQuery.of(context).size.height * 0.65,
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
                              const SizedBox(height: 20),
                              // ======================== Email TextFormField =============================
                              InputField(
                                key: const ValueKey("email"),
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
                              ),
                              const SizedBox(height: 20),
                              // ======================== Username TextFormField =============================
                              if (authMode == AuthMode.signUp)
                                InputField(
                                  key: const ValueKey("username"),
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
                                ),
                              const SizedBox(height: 20),
                              // ======================== Password TextFormField =============================
                              InputField(
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
                              ),
                              const SizedBox(height: 20),
                              // ======================== Confirm Password TextFormField =============================
                              if (authMode == AuthMode.signUp)
                                InputField(
                                  key: const ValueKey("Confirmation"),
                                  textCapitalization: TextCapitalization.none,
                                  hint: "Confirm your password",
                                  obsecure: confirmPassVisiblity,
                                  icon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        confirmPassVisiblity =
                                            !confirmPassVisiblity;
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
                              SizedBox(
                                height: authMode == AuthMode.signIn ? 30 : 40,
                              ),
                              // ======================== (Log in - Sign up ) Button =============================
                              Align(
                                alignment: Alignment.center,
                                child: ConditionalBuilder(
                                  condition: state is! SignInLoadingState &&
                                      state is! SignUpLoadingState,
                                  builder: (context) => DefaultButton(
                                    width: 110,
                                    height: 15,
                                    buttonText: authMode == AuthMode.signIn
                                        ? "Sign In"
                                        : "Sign Up",
                                    onPressed: () => signInOrSignUp(context),
                                  ),
                                  fallback: (context) => const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryClr,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    authMode == AuthMode.signIn
                                        ? "Don't have an account?"
                                        : "Already have an account?",
                                    style: subTitleStyle.copyWith(fontSize: 15),
                                  ),
                                  // ======================== (Sign in / Sign up) Button =============================
                                  TextButton(
                                    onPressed: switchAuthMode,
                                    child: Text(
                                      authMode == AuthMode.signIn
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
        },
      ),
    );
  }

  //=========== For Switching Between Auth Modes ===========
  void switchAuthMode() {
    if (authMode == AuthMode.signIn) {
      setState(() {
        authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        authMode = AuthMode.signIn;
      });
    }
  }

  //=========== For Signing The User In or Up ===========
  void signInOrSignUp(BuildContext ctx) {
    if (_formKey.currentState!.validate()) {
      //======== Signing The User In ========
      if (authMode == AuthMode.signIn) {
        FocusScope.of(ctx).unfocus();
        AuthScreenCubit.getObject(ctx).userSignIn(
          context: ctx,
          email: _emailController.text.trim(),
          password: _passController.text,
        );
      }
      //======== Signing The User Up ========
      else if (authMode == AuthMode.signUp) {
        FocusScope.of(ctx).unfocus();
        AuthScreenCubit.getObject(ctx).userSignUp(
          context: ctx,
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passController.text,
        );
      }
    }
  }
}
