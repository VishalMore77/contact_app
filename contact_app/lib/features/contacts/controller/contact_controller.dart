import 'package:contact_app/data/services/connectivity_service.dart';
import 'package:contact_app/data/services/firebase_service.dart';
import 'package:contact_app/features/contacts/model/contact_model.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();

  final RxList<ContactModel> contacts = <ContactModel>[].obs;
  final RxList<ContactModel> favoriteContacts = <ContactModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadContacts();
    loadFavoriteContacts();
    _listenToContactsStream();
  }

  void _listenToContactsStream() {
    _firebaseService.getContactsStream().listen(
      (contactsList) {
        contacts.value = contactsList;
        loadFavoriteContacts();
      },
      onError: (error) {
        Get.snackbar('Error', 'Failed to sync contacts: $error');
      },
    );
  }

  Future<void> loadContacts() async {
    try {
      isLoading.value = true;
      
      final isConnected = await _connectivityService.checkConnection();
      if (!isConnected) {
        Get.snackbar('No Internet', 'Please check your internet connection');
        return;
      }

      final loadedContacts = await _firebaseService.getAllContacts();
      contacts.value = loadedContacts;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load contacts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFavoriteContacts() async {
    try {
      final isConnected = await _connectivityService.checkConnection();
      if (!isConnected) {
        return;
      }

      final loadedFavorites = await _firebaseService.getFavoriteContacts();
      favoriteContacts.value = loadedFavorites;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load favorite contacts: $e');
    }
  }

  List<ContactModel> get filteredContacts {
    if (searchQuery.value.isEmpty) {
      return contacts;
    }
    return contacts.where((contact) {
      return contact.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          contact.phone.contains(searchQuery.value);
    }).toList();
  }



  Future<void> addContact(ContactModel contact) async {
    try {
      final isConnected = await _connectivityService.checkConnection();
      if (!isConnected) {
        Get.snackbar('No Internet', 'Cannot add contact without internet');
        return;
      }

      isLoading.value = true;
      final docId = await _firebaseService.addContact(contact);
      Get.back();
      Get.snackbar('Success', 'Contact added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add contact: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateContact(ContactModel contact) async {
    try {
      final isConnected = await _connectivityService.checkConnection();
      if (!isConnected) {
        Get.snackbar('No Internet', 'Cannot update contact without internet');
        return;
      }

      isLoading.value = true;
      await _firebaseService.updateContact(contact);
      Get.back();
      Get.snackbar('Success', 'Contact updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update contact: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      final isConnected = await _connectivityService.checkConnection();
      if (!isConnected) {
        Get.snackbar('No Internet', 'Cannot delete contact without internet');
        return;
      }

      isLoading.value = true;
      await _firebaseService.deleteContact(id);
      Get.back();
      Get.snackbar('Success', 'Contact deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete contact: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(ContactModel contact) async {
    try {
      final isConnected = await _connectivityService.checkConnection();
      if (!isConnected) {
        Get.snackbar('No Internet', 'Cannot update favorite without internet');
        return;
      }

      final updatedContact = contact.copyWith(isFavorite: !contact.isFavorite);
      await _firebaseService.updateContact(updatedContact);
      await loadFavoriteContacts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite: $e');
    }
  }

  Future<void> makeCall(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar('Error', 'Cannot make call');
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
