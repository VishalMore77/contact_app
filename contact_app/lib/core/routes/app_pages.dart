import 'package:contact_app/features/contacts/bindings/contact_binding.dart';
import 'package:contact_app/features/contacts/model/contact_model.dart';
import 'package:contact_app/features/contacts/view/add_edit_contact_screen.dart';
import 'package:contact_app/features/contacts/view/contact_detail_screen.dart';
import 'package:contact_app/features/contacts/view/contacts_screen.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.contacts,
      page: () => const ContactsScreen(),
      binding: ContactBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.contactDetail,
      page: () => ContactDetailScreen(contact: Get.arguments as ContactModel),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.addContact,
      page: () => const AddEditContactScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.editContact,
      page: () => AddEditContactScreen(contact: Get.arguments as ContactModel),
      transition: Transition.rightToLeft,
    ),
  ];
}
