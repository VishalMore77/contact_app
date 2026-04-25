import 'package:contact_app/core/routes/app_routes.dart';
import 'package:contact_app/core/theme/app_theme.dart';
import 'package:contact_app/features/contacts/controller/contact_controller.dart';
import 'package:contact_app/features/contacts/widgets/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactController controller = Get.find();
    final RxInt currentIndex = 0.obs;
    final TextEditingController contactsSearchController = TextEditingController();
    final TextEditingController favoritesSearchController = TextEditingController();
    final RxString contactsSearchQuery = ''.obs;
    final RxString favoritesSearchQuery = ''.obs;
    final PageController pageController = PageController();

    return Obx(() {
      return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            currentIndex.value = index;
          },
          children: [
            _buildContactsTab(controller, contactsSearchController, contactsSearchQuery),
            _buildFavoritesTab(controller, favoritesSearchController, favoritesSearchQuery),
          ],
        ),
        floatingActionButton: currentIndex.value == 0
            ? FloatingActionButton(
                onPressed: () => Get.toNamed(AppRoutes.addContact),
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              currentIndex: currentIndex.value,
              onTap: (index) {
                currentIndex.value = index;
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.contacts),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: 'Favourite',
                ),
              ],
            )),
      );
    });
  }

  Widget _buildContactsTab(ContactController controller, TextEditingController searchController, RxString searchQuery) {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: Column(
        children: [
          Container(
            color: AppTheme.darkSurface,
            padding: EdgeInsets.only(
              top: MediaQuery.of(Get.context!).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) => searchQuery.value = value,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search contacts',
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                suffixIcon: Obx(() => searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                        onPressed: () {
                          searchController.clear();
                          searchQuery.value = '';
                        },
                      )
                    : const SizedBox()),
                filled: true,
                fillColor: AppTheme.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: _buildContactsList(controller, searchQuery),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab(ContactController controller, TextEditingController searchController, RxString searchQuery) {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: Column(
        children: [
          Container(
            color: AppTheme.darkSurface,
            padding: EdgeInsets.only(
              top: MediaQuery.of(Get.context!).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) => searchQuery.value = value,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search favorites',
                hintStyle: const TextStyle(color: AppTheme.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                suffixIcon: Obx(() => searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                        onPressed: () {
                          searchController.clear();
                          searchQuery.value = '';
                        },
                      )
                    : const SizedBox()),
                filled: true,
                fillColor: AppTheme.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: _buildFavoritesList(controller, searchQuery),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList(ContactController controller, RxString searchQuery) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final contacts = controller.contacts
          .where((contact) =>
              searchQuery.value.isEmpty ||
              contact.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              contact.phone.contains(searchQuery.value))
          .toList();

      if (contacts.isEmpty) {
        return Center(
          child: Text(
            searchQuery.value.isEmpty
                ? 'No contacts found'
                : 'No contacts match "${searchQuery.value}"',
            style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.loadContacts();
            await controller.loadFavoriteContacts();
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ContactTile(
                contact: contact,
                index: index,
                onTap: () {
                  FocusScope.of(Get.context!).unfocus();
                  Get.toNamed(AppRoutes.contactDetail, arguments: contact);
                },
                onFavoriteToggle: () => controller.toggleFavorite(contact),
                onCall: () => controller.makeCall(contact.phone),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildFavoritesList(ContactController controller, RxString searchQuery) {
    return Obx(() {
      final favoriteContacts = controller.favoriteContacts
          .where((contact) =>
              searchQuery.value.isEmpty ||
              contact.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              contact.phone.contains(searchQuery.value))
          .toList();

      if (favoriteContacts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_border, size: 80, color: AppTheme.textSecondary.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(
                searchQuery.value.isEmpty
                    ? 'No favorite contacts'
                    : 'No favorites match "${searchQuery.value}"',
                style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
              ),
              if (searchQuery.value.isEmpty)
                const SizedBox(height: 8),
              if (searchQuery.value.isEmpty)
                const Text(
                  'Tap the star icon to add favorites',
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.loadFavoriteContacts();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: favoriteContacts.length,
            itemBuilder: (context, index) {
              final contact = favoriteContacts[index];
              return ContactTile(
                contact: contact,
                index: index,
                onTap: () {
                  FocusScope.of(Get.context!).unfocus();
                  Get.toNamed(AppRoutes.contactDetail, arguments: contact);
                },
                onFavoriteToggle: () => controller.toggleFavorite(contact),
                onCall: () => controller.makeCall(contact.phone),
              );
            },
          ),
        ),
      );
    });
  }
}
