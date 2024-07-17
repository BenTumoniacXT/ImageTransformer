import 'package:get/get.dart';
import 'controller.dart';

class T2IBindingV2 extends Bindings {
  @override
  void dependencies() {
    Get.put<T2IControllerV2>(
      T2IControllerV2(),
    );
  }
}
