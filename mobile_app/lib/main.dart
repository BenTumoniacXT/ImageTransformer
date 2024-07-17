import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'utilities/app_pages.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //await Future.delayed(const Duration(seconds: 3));

  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);
    FlutterNativeSplash.remove();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Transformer - Beta Edition',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        fontFamily: 'SourceSans3',
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: 0.8,
          fontSizeDelta: 3,
        ),
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}