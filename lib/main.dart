import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '/screens/splash_screen.dart';
import '/services/theme_services.dart';
import '/theme.dart';
import 'firebase_options.dart';

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

    // =================== Initialize Get Storage To Get The Stored Theme ===================
    await GetStorage.init();

    // =================== Running The App ===================
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeServices().theme,
      title: 'Chatter App',
      debugShowCheckedModeBanner: false,
      home: const MySplashScreen(),
    );
  }
}
