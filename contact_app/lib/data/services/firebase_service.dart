import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/features/contacts/model/contact_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'contacts';

  // Get contacts collection reference
  CollectionReference get _contactsCollection =>
      _firestore.collection(_collectionName);

  // Add contact to Firebase
  Future<String> addContact(ContactModel contact) async {
    try {
      final docRef = await _contactsCollection.add(contact.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add contact: $e');
    }
  }

  // Get all contacts from Firebase
  Future<List<ContactModel>> getAllContacts() async {
    try {
      final querySnapshot = await _contactsCollection
          .orderBy('name')
          .get();
      
      return querySnapshot.docs
          .map((doc) => ContactModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch contacts: $e');
    }
  }

  // Update contact in Firebase
  Future<void> updateContact(ContactModel contact) async {
    try {
      if (contact.id == null) {
        throw Exception('Contact ID is required for update');
      }
      await _contactsCollection.doc(contact.id).update(contact.toJson());
    } catch (e) {
      throw Exception('Failed to update contact: $e');
    }
  }

  // Delete contact from Firebase
  Future<void> deleteContact(String id) async {
    try {
      await _contactsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete contact: $e');
    }
  }

  // Get real-time contacts stream
  Stream<List<ContactModel>> getContactsStream() {
    return _contactsCollection
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ContactModel.fromJson({
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                }))
            .toList());
  }

  // Get favorite contacts
  Future<List<ContactModel>> getFavoriteContacts() async {
    try {
      final querySnapshot = await _contactsCollection
          .where('isFavorite', isEqualTo: 1)
          .get();
      
      final favorites = querySnapshot.docs
          .map((doc) => ContactModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
      
      // Sort by name in memory instead of Firestore
      favorites.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      
      return favorites;
    } catch (e) {
      throw Exception('Failed to fetch favorite contacts: $e');
    }
  }
}
