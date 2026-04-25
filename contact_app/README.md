# Contact App

A modern Flutter contacts application built with GetX state management, Firebase Firestore, and comprehensive animations.

## Features

### Core Functionality
- **Contact Management**: Create, read, update, and delete contacts
- **Favorites System**: Mark contacts as favorites with dedicated favorites tab
- **Search**: Independent search functionality for Contacts and Favorites tabs with persistent search bars
- **Phone Calls**: Direct phone call integration using url_launcher
- **Real-time Sync**: Live updates from Firebase Firestore using streams
- **Connectivity Monitoring**: Internet connectivity checking with user notifications

### Architecture
- **Pattern**: MVC (Model-View-Controller) with feature-based structure
- **State Management**: GetX for reactive state management
- **Navigation**: Named routes with GetX routing and transitions
- **Backend**: Firebase Firestore for cloud storage
- **Dependency Injection**: GetX bindings for service and controller management

### UI/UX
- **Dark Theme**: Custom dark theme with teal accent (#00897B)
- **Animations**: 
  - Hero transitions for avatars between screens
  - Fade and slide transitions for screen navigation
  - Staggered form field animations (100ms delay between fields)
  - Shake animation for validation errors
  - Animated favorite icon with scale effect
  - List item entrance animations with staggered delays
- **Dynamic Avatar Colors**: 8 predefined colors assigned based on contact name's first character
- **Persistent Search Bars**: Always-visible search in both Contacts and Favorites tabs
- **Bottom Navigation**: Tab switching between Home and Favourite with labels
- **Touch Targets**: Minimum 48x48 touch targets for accessibility compliance
- **Focus Management**: Automatic keyboard dismissal when tapping outside or on contact cards

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_animations.dart      # Animation durations, curves, offsets
│   │   └── app_constants.dart       # App-wide string constants
│   ├── routes/
│   │   ├── app_routes.dart          # Route name constants
│   │   └── app_pages.dart           # GetPage route configuration with transitions
│   ├── theme/
│   │   └── app_theme.dart           # Dark theme with colors and getAvatarColor()
│   └── widgets/
│       └── animated_widgets.dart    # Reusable animation widgets
├── data/
│   └── services/
│       ├── firebase_service.dart    # Firestore CRUD operations and streams
│       └── connectivity_service.dart # Internet connectivity monitoring
├── features/
│   └── contacts/
│       ├── bindings/
│       │   └── contact_binding.dart # GetX dependency injection
│       ├── controller/
│       │   └── contact_controller.dart # Business logic and state management
│       ├── model/
│       │   └── contact_model.dart   # Contact data model with JSON serialization
│       ├── view/
│       │   ├── contacts_screen.dart # Main screen with PageView for tabs
│       │   ├── contact_detail_screen.dart # Contact details with Hero animation
│       │   └── add_edit_contact_screen.dart # Add/Edit form with validation
│       └── widgets/
│           └── contact_tile.dart    # Contact list item with animations
├── firebase_options.dart            # Firebase configuration
└── main.dart                        # App entry point with Firebase initialization
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6                        # State management & routing
  firebase_core: ^3.8.1              # Firebase initialization
  cloud_firestore: ^5.5.0            # Cloud database
  url_launcher: ^6.3.1               # Phone call functionality
  connectivity_plus: ^6.1.2          # Network connectivity monitoring
```

## Setup Instructions

### 1. Prerequisites
- Flutter SDK (latest stable version)
- Firebase account
- Android Studio / VS Code

### 2. Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android/iOS app to your Firebase project
3. Download `google-services.json` (Android) and place in `android/app/`
4. Download `GoogleService-Info.plist` (iOS) and place in `ios/Runner/`
5. Run `flutterfire configure` to generate `firebase_options.dart`
6. Enable Firestore Database in Firebase Console
7. Set Firestore rules (for testing only - update for production):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

### 3. Installation
```bash
# Clone the repository
git clone <repository-url>

# Navigate to project directory
cd contact_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Navigation Routes

| Route | Path | Screen | Transition | Arguments |
|-------|------|--------|------------|----------|
| Contacts | `/` | ContactsScreen | fadeIn | None |
| Contact Detail | `/contact-detail` | ContactDetailScreen | cupertino | ContactModel |
| Add Contact | `/add-contact` | AddEditContactScreen | fadeIn | None |
| Edit Contact | `/edit-contact` | AddEditContactScreen | rightToLeft | ContactModel |

### Navigation Usage
```dart
// Navigate to contact detail
Get.toNamed(AppRoutes.contactDetail, arguments: contact);

// Navigate to add contact
Get.toNamed(AppRoutes.addContact);

// Navigate to edit contact
Get.toNamed(AppRoutes.editContact, arguments: contact);

// Go back
Get.back();
```

## Theme Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Background | #1C1C1E | Main background |
| Surface | #2C2C2E | AppBar, cards, bottom nav |
| Card | #3A3A3C | Input fields, elevated surfaces |
| Primary Teal | #00897B | Buttons, icons, accents |
| Text Primary | #FFFFFF | Main text |
| Text Secondary | #B0B0B0 | Subtitles, hints |
| Divider | #3A3A3C | List dividers |

### Avatar Colors (8 colors)
- Teal (#00897B)
- Orange (#D84315)
- Blue (#1976D2)
- Red (#C62828)
- Green (#388E3C)
- Purple (#7B1FA2)
- Deep Orange (#F57C00)
- Cyan (#0097A7)

## Key Features Implementation

### Named Routes with GetX
All navigation uses GetX named routes defined in `app_routes.dart` and configured in `app_pages.dart`:
```dart
// Route definition
class AppRoutes {
  static const String contacts = '/';
  static const String contactDetail = '/contact-detail';
}

// Route configuration
GetPage(
  name: AppRoutes.contactDetail,
  page: () => ContactDetailScreen(contact: Get.arguments as ContactModel),
  transition: Transition.cupertino,
)
```

### Real-time Firestore Streams
Contacts automatically sync using Firestore snapshots:
```dart
Stream<List<ContactModel>> getContactsStream() {
  return _contactsCollection
      .orderBy('name')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ContactModel.fromJson({...}))
          .toList());
}
```

### Connectivity Monitoring
Internet connectivity is monitored and users are notified:
```dart
class ConnectivityService extends GetxController {
  final RxBool isConnected = true.obs;
  
  @override
  void onInit() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
}
```

### Dynamic Avatar Colors
Colors assigned based on first character of contact name:
```dart
static Color getAvatarColor(String name) {
  if (name.isEmpty) return avatarColors[0];
  final index = name.codeUnitAt(0) % avatarColors.length;
  return avatarColors[index];
}
```

### Independent Search Controllers
Separate search states for Contacts and Favorites tabs:
```dart
final TextEditingController contactsSearchController = TextEditingController();
final TextEditingController favoritesSearchController = TextEditingController();
final RxString contactsSearchQuery = ''.obs;
final RxString favoritesSearchQuery = ''.obs;
```

### Animation Widgets
Reusable animation components:
- **AnimatedScaleButton**: Scale animation on tap
- **FadeSlideTransition**: Fade in with slide from bottom
- **ShakeWidget**: Shake animation for validation errors
- **AnimatedListItem**: Staggered entrance animation for list items
- **AnimatedFavoriteIcon**: Animated favorite toggle with IconButton

## Contact Model

```dart
class ContactModel {
  final String? id;           // Firebase document ID
  final String name;          // Required
  final String phone;         // Required
  final String? email;        // Optional
  final bool isFavorite;      // Stored as 1/0 in Firestore
  
  // Methods:
  // - toJson(): Convert to Firestore map
  // - fromJson(): Create from Firestore document
  // - copyWith(): Create modified copy
  // - getInitials(): Get 1-2 character initials
}
```

## Firestore Data Structure

**Collection**: `contacts`

**Document Fields**:
```json
{
  "name": "John Doe",
  "phone": "+1234567890",
  "email": "john@example.com",
  "isFavorite": 1
}
```

Note: `isFavorite` is stored as integer (1 for true, 0 for false) for Firestore querying.

