import 'package:contact_app/core/theme/app_theme.dart';
import 'package:contact_app/core/widgets/animated_widgets.dart';
import 'package:contact_app/features/contacts/model/contact_model.dart';
import 'package:flutter/material.dart';


class ContactTile extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onCall;
  final int index;

  const ContactTile({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onFavoriteToggle,
    this.onCall,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedListItem(
      index: index,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppTheme.darkSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border(
            bottom: BorderSide(
              color: AppTheme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Hero(
                    tag: 'contact_avatar_${contact.id}',
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.getAvatarColor(contact.name),
                      child: Text(
                        contact.getInitials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          contact.phone,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onCall != null)
                    IconButton(
                      onPressed: onCall,
                      icon: const Icon(
                        Icons.call,
                        color: AppTheme.primaryTeal,
                        size: 22,
                      ),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                    ),
                  const SizedBox(width: 4),
                  AnimatedFavoriteIcon(
                    isFavorite: contact.isFavorite,
                    onTap: onFavoriteToggle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
