import 'package:contact_app/core/constants/app_animations.dart';
import 'package:contact_app/core/constants/app_constants.dart';
import 'package:contact_app/core/theme/app_theme.dart';
import 'package:contact_app/core/widgets/animated_widgets.dart';
import 'package:contact_app/features/contacts/controller/contact_controller.dart';
import 'package:contact_app/features/contacts/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditContactScreen extends StatefulWidget {
  final ContactModel? contact;

  const AddEditContactScreen({super.key, this.contact});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final ContactController _controller = Get.find();
  bool _shakeForm = false;

  bool get isEditing => widget.contact != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
      _emailController.text = widget.contact!.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? AppConstants.editContact : AppConstants.addContact),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ShakeWidget(
          shake: _shakeForm,
          onComplete: () => setState(() => _shakeForm = false),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                FadeSlideTransition(
                  duration: AppAnimations.normal,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryTeal,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                FadeSlideTransition(
                  duration: AppAnimations.normal,
                  delay: const Duration(milliseconds: 100),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FadeSlideTransition(
                  duration: AppAnimations.normal,
                  delay: const Duration(milliseconds: 200),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone *',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a phone number';
                      }
                      if (value.length < 10) {
                        return 'Phone number must be at least 10 digits';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FadeSlideTransition(
                  duration: AppAnimations.normal,
                  delay: const Duration(milliseconds: 300),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                FadeSlideTransition(
                  duration: AppAnimations.normal,
                  delay: const Duration(milliseconds: 400),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveContact,
                      child: Text(
                        isEditing ? 'Update Contact' : 'Save Contact',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final contact = ContactModel(
        id: widget.contact?.id,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        isFavorite: widget.contact?.isFavorite ?? false,
      );

      if (isEditing) {
        _controller.updateContact(contact);
      } else {
        _controller.addContact(contact);
      }
    } else {
      setState(() => _shakeForm = true);
    }
  }
}
