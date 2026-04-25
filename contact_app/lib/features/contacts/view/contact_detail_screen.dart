import 'package:contact_app/core/constants/app_constants.dart';
import 'package:contact_app/core/routes/app_routes.dart';
import 'package:contact_app/core/theme/app_theme.dart';
import 'package:contact_app/core/widgets/animated_widgets.dart';
import 'package:contact_app/features/contacts/controller/contact_controller.dart';
import 'package:contact_app/features/contacts/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ContactDetailScreen extends StatelessWidget {
  final ContactModel contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final ContactController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.contactDetails),
        actions: [
          Obx(() {
            // Find the current contact from the controller to get updated favorite status
            final currentContact = controller.contacts.firstWhere(
              (c) => c.id == contact.id,
              orElse: () => contact,
            );
            return AnimatedFavoriteIcon(
              isFavorite: currentContact.isFavorite,
              onTap: () => controller.toggleFavorite(currentContact),
            );
          }),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed(AppRoutes.editContact, arguments: contact),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, controller),
          ),
        ],
      ),
      body: FadeSlideTransition(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Hero(
                tag: 'contact_avatar_${contact.id}',
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.getAvatarColor(contact.name),
                  child: Text(
                    contact.getInitials(),
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                contact.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              _buildInfoCard(
                icon: Icons.phone,
                title: 'Phone',
                value: contact.phone,
                onTap: () => controller.makeCall(contact.phone),
              ),
              if (contact.email != null && contact.email!.isNotEmpty)
                _buildInfoCard(
                  icon: Icons.email,
                  title: 'Email',
                  value: contact.email!,
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => controller.makeCall(contact.phone),
                    icon: const Icon(Icons.call),
                    label: const Text('Call', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryTeal),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ContactController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text(AppConstants.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteContact(contact.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
