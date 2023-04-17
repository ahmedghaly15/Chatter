import 'package:chat_app/cubit/cubit.dart';
import 'package:chat_app/shared/bloc_observer.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/screens/splash_screen.dart';
import '/services/theme_services.dart';
import '/theme.dart';
import 'firebase_options.dart';
import 'network/local/cache_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // =================== Setting Preferred Orientations ===================
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    // =================== Initialize Firebase ===================
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    //===================== Initializing GetStorage =====================
    await GetStorage.init();

    //===================== Observing My Bloc =====================
    Bloc.observer = MyBlocObserver();

    //===================== Initializing SharedPref =====================
    await CacheHelper.initSharedPref();

    uId = CacheHelper.getStringData(key: 'uId');

    // =================== Running The App ===================
    runApp(const ChatterApp());
  });
}

class ChatterApp extends StatelessWidget {
  const ChatterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatterAppCubit()..getUserData(uId),
      child: GetMaterialApp(
        theme: Themes.lightTheme,
        darkTheme: Themes.darkTheme,
        themeMode: ThemeServices().theme,
        title: 'Chatter App',
        debugShowCheckedModeBanner: false,
        home: const MySplashScreen(),
      ),
    );
  }
}
