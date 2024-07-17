import 'package:get/get.dart';
import 'home_page.dart';
import 'home_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.homePage;

  static final routes = [
    GetPage(
      name: _Paths.homePage,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}