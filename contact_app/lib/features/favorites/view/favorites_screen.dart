import 'package:contact_app/core/theme/app_theme.dart';
import 'package:contact_app/features/contacts/controller/contact_controller.dart';
import 'package:contact_app/features/contacts/view/contact_detail_screen.dart';
import 'package:contact_app/features/contacts/widgets/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactController controller = Get.find();
    final TextEditingController searchController = TextEditingController();

    return Column(
      children: [
        Container(
          color: AppTheme.darkSurface,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            bottom: 12,
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) => controller.updateSearchQuery(value),
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search favorites',
              hintStyle: const TextStyle(color: AppTheme.textSecondary),
              prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
              suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                      onPressed: () {
                        searchController.clear();
                        controller.updateSearchQuery('');
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildFavoritesList(controller),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesList(ContactController controller) {
    return Obx(() {
      final favoriteContacts = controller.favoriteContacts
          .where((contact) =>
              controller.searchQuery.value.isEmpty ||
              contact.name.toLowerCase().contains(controller.searchQuery.value.toLowerCase()) ||
              contact.phone.contains(controller.searchQuery.value))
          .toList();

      if (favoriteContacts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_border, size: 80, color: AppTheme.textSecondary.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(
                controller.searchQuery.value.isEmpty
                    ? 'No favorite contacts'
                    : 'No favorites match "${controller.searchQuery.value}"',
                style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
              ),
              if (controller.searchQuery.value.isEmpty)
                const SizedBox(height: 8),
              if (controller.searchQuery.value.isEmpty)
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
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: favoriteContacts.length,
          itemBuilder: (context, index) {
            final contact = favoriteContacts[index];
            return ContactTile(
              contact: contact,
              index: index,
              onTap: () => Get.to(
                () => ContactDetailScreen(contact: contact),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 300),
              ),
              onFavoriteToggle: () => controller.toggleFavorite(contact),
              onCall: () => controller.makeCall(contact.phone),
            );
          },
        ),
      );
    });
  }
}
