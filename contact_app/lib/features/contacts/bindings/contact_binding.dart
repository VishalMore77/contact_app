import 'package:contact_app/data/services/connectivity_service.dart';
import 'package:contact_app/features/contacts/controller/contact_controller.dart';
import 'package:get/get.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConnectivityService>(() => ConnectivityService());
    Get.lazyPut<ContactController>(() => ContactController());
  }
}
