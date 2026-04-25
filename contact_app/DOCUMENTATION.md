# Contact App - Complete Documentation

## Table of Contents
1. [Overview](#overview)
2. [Features](#features)
3. [Installation](#installation)
4. [Usage Instructions](#usage-instructions)
5. [Architecture](#architecture)
6. [Firebase Configuration](#firebase-configuration)
7. [Troubleshooting](#troubleshooting)

---

## Overview

Contact App is a modern, feature-rich mobile application built with Flutter that allows users to manage their contacts efficiently. The app uses Firebase Firestore for cloud storage, GetX for state management, and includes comprehensive animations for a smooth user experience.

### Key Highlights
- **Platform**: Flutter (iOS & Android)
- **State Management**: GetX
- **Backend**: Firebase Firestore
- **Architecture**: MVC with feature-based structure
- **Theme**: Dark theme with teal accents

---

## Features

### 1. Contact Management

#### Add New Contact
- Create contacts with name, phone number, and optional email
- Form validation ensures data integrity
- Real-time validation feedback with shake animation
- Staggered field animations for smooth UX

**Required Fields:**
- Name (minimum 1 character)
- Phone (minimum 10 digits)

**Optional Fields:**
- Email (validated format)

#### View Contact Details
- Full contact information display
- Hero animation for avatar transition
- Quick call button
- Edit and delete options
- Favorite toggle in app bar

#### Edit Contact
- Update existing contact information
- Pre-filled form with current data
- Same validation as add contact
- Smooth right-to-left transition

#### Delete Contact
- Confirmation dialog before deletion
- Permanent removal from Firestore
- Automatic UI update after deletion

### 2. Favorites System

#### Mark as Favorite
- Star icon on contact cards
- Animated favorite toggle
- Instant visual feedback
- Syncs with Firestore in real-time

#### Favorites Tab
- Dedicated tab for favorite contacts
- Independent search functionality
- Empty state with helpful message
- Pull-to-refresh support

### 3. Search Functionality

#### Contacts Search
- Persistent search bar always visible
- Search by name or phone number
- Case-insensitive matching
- Clear button when text is entered
- Real-time filtering

#### Favorites Search
- Separate search state from contacts
- Same search capabilities
- Independent query management
- No interference between tabs

### 4. Phone Integration

#### Direct Calling
- Tap call icon on contact card
- Quick call button in detail screen
- Uses device's default phone app
- Handles permission requests automatically

### 5. Real-time Synchronization

#### Firestore Streams
- Live updates from cloud database
- Automatic UI refresh on data changes
- No manual refresh needed
- Instant sync across devices

#### Connectivity Monitoring
- Internet connection status tracking
- User notifications for offline state
- Prevents operations without internet
- Automatic reconnection detection

### 6. Animations

#### Screen Transitions
- **Fade In**: Add contact, main screen
- **Cupertino**: Contact detail (iOS-style slide)
- **Right to Left**: Edit contact

#### UI Animations
- **Hero Animation**: Avatar transitions between screens
- **Fade Slide**: Content entrance animations
- **Staggered List**: Items appear with delays
- **Scale Animation**: Button press feedback
- **Shake Animation**: Form validation errors
- **Favorite Icon**: Animated star toggle

### 7. User Interface

#### Dark Theme
- Custom dark color scheme
- Teal accent color (#00897B)
- High contrast for readability
- Consistent styling throughout

#### Dynamic Avatars
- Circular avatars with initials
- 8 predefined colors
- Color assigned by name's first character
- Consistent colors for same contacts

#### Bottom Navigation
- Two tabs: Home and Favourite
- Labels always visible
- Smooth page transitions
- Current tab highlighting

#### Touch Targets
- Minimum 48x48 pixel touch areas
- Accessibility compliant
- Easy tapping on all buttons
- Proper spacing between elements

#### Focus Management
- Keyboard dismissal on outside tap
- Keyboard dismissal on contact tap
- Smooth focus transitions
- No keyboard overlap issues

---

## Installation

### Prerequisites

Before installing the Contact App, ensure you have:

1. **Flutter SDK** (3.0.0 or higher)
   ```bash
   flutter --version
   ```

2. **Dart SDK** (included with Flutter)

3. **Android Studio** or **VS Code** with Flutter extensions

4. **Git** for cloning the repository

5. **Firebase Account** (free tier is sufficient)

6. **Physical Device or Emulator**
   - Android: API level 21 or higher
   - iOS: iOS 12.0 or higher

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone <repository-url>

# Navigate to project directory
cd contact_app
```

### Step 2: Install Dependencies

```bash
# Get all Flutter packages
flutter pub get

# Verify installation
flutter doctor
```

### Step 3: Firebase Setup

#### 3.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name (e.g., "Contact App")
4. Disable Google Analytics (optional)
5. Click "Create project"

#### 3.2 Add Android App

1. In Firebase Console, click "Add app" → Android icon
2. Enter package name: `com.example.contact_app`
3. Download `google-services.json`
4. Place file in `android/app/` directory

#### 3.3 Add iOS App

1. In Firebase Console, click "Add app" → iOS icon
2. Enter bundle ID: `com.example.contactApp`
3. Download `GoogleService-Info.plist`
4. Place file in `ios/Runner/` directory

#### 3.4 Enable Firestore Database

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Select "Start in test mode"
4. Choose a location (closest to your users)
5. Click "Enable"

#### 3.5 Configure Firestore Rules

In Firestore Console, go to "Rules" tab and paste:

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

**⚠️ Warning**: These rules allow public access. For production, implement proper authentication and security rules.

#### 3.6 Generate Firebase Options

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

Select your Firebase project and platforms (Android/iOS).

### Step 4: Run the App

```bash
# Check connected devices
flutter devices

# Run on connected device
flutter run

# Run in release mode
flutter run --release
```

---

## Usage Instructions

### Getting Started

#### First Launch
1. Open the app
2. You'll see an empty contacts list
3. Tap the floating action button (+) to add your first contact

### Managing Contacts

#### Adding a Contact

1. **Tap** the floating action button (+) at the bottom right
2. **Enter** contact name (required)
3. **Enter** phone number (required, minimum 10 digits)
4. **Enter** email address (optional)
5. **Tap** "Save Contact" button
6. Contact appears in the list automatically

**Validation Rules:**
- Name cannot be empty
- Phone must be at least 10 digits
- Email must be valid format (if provided)
- Form shakes if validation fails

#### Viewing Contact Details

1. **Tap** any contact card in the list
2. View full contact information
3. Avatar animates with Hero transition
4. See name, phone, and email (if available)

**Available Actions:**
- **Call**: Tap the call button to dial
- **Edit**: Tap edit icon in app bar
- **Delete**: Tap delete icon in app bar
- **Favorite**: Tap star icon in app bar

#### Editing a Contact

1. **Open** contact details
2. **Tap** edit icon (pencil) in app bar
3. **Modify** any field
4. **Tap** "Update Contact" button
5. Changes sync immediately

#### Deleting a Contact

1. **Open** contact details
2. **Tap** delete icon (trash) in app bar
3. **Confirm** deletion in dialog
4. Contact removed from all lists

### Using Favorites

#### Adding to Favorites

**Method 1: From Contact List**
1. Find the contact
2. Tap the star icon on the right
3. Star fills with color
4. Contact appears in Favorites tab

**Method 2: From Contact Details**
1. Open contact details
2. Tap star icon in app bar
3. Contact added to favorites

#### Viewing Favorites

1. **Tap** "Favourite" tab in bottom navigation
2. See all favorite contacts
3. Same functionality as Contacts tab
4. Independent search available

#### Removing from Favorites

1. Tap the filled star icon
2. Star becomes outlined
3. Contact removed from Favorites tab
4. Still visible in Contacts tab

### Searching Contacts

#### Search in Contacts Tab

1. **Tap** the search field at the top
2. **Type** name or phone number
3. Results filter in real-time
4. **Tap** X icon to clear search

**Search Features:**
- Case-insensitive
- Matches partial names
- Matches partial phone numbers
- Instant results

#### Search in Favorites Tab

1. **Switch** to Favorites tab
2. **Tap** the search field
3. **Type** to filter favorites
4. Independent from Contacts search

### Making Phone Calls

#### From Contact List

1. Find the contact
2. Tap the phone icon on the right
3. Device's phone app opens
4. Number pre-filled and ready to call

#### From Contact Details

1. Open contact details
2. Tap the "Call" button at the bottom
3. Phone app opens with number

**Note**: Requires phone call permissions on first use.

### Refreshing Data

#### Pull to Refresh

1. Scroll to top of list
2. Pull down and release
3. Data reloads from Firestore
4. Loading indicator appears

**Auto-refresh**: Data updates automatically via real-time streams.

### Navigation

#### Tab Switching

**Method 1: Bottom Navigation**
1. Tap "Home" for Contacts
2. Tap "Favourite" for Favorites

**Method 2: Swipe**
1. Swipe left to go to Favorites
2. Swipe right to go to Contacts

#### Going Back

- **Android**: Use back button
- **iOS**: Swipe from left edge
- **Both**: Tap back arrow in app bar

### Keyboard Management

#### Dismissing Keyboard

**Method 1**: Tap anywhere outside text field
**Method 2**: Tap on a contact card
**Method 3**: Tap back button

The keyboard automatically dismisses when navigating away.

---

## Architecture

### Design Pattern: MVC

#### Model
- `ContactModel`: Data structure for contacts
- JSON serialization for Firestore
- Business logic for data transformation

#### View
- `ContactsScreen`: Main screen with tabs
- `ContactDetailScreen`: Detail view
- `AddEditContactScreen`: Form screen
- `ContactTile`: List item widget

#### Controller
- `ContactController`: Business logic and state
- Manages CRUD operations
- Handles connectivity checks
- Coordinates with services

### State Management: GetX

#### Reactive Variables
```dart
RxList<ContactModel> contacts
RxList<ContactModel> favoriteContacts
RxBool isLoading
RxString searchQuery
```

#### Dependency Injection
```dart
ContactBinding: Initializes controllers and services
Get.lazyPut(): Lazy loading of dependencies
Get.find(): Retrieves existing instances
```

### Services Layer

#### FirebaseService
- Singleton pattern
- CRUD operations
- Real-time streams
- Error handling

#### ConnectivityService
- GetX controller
- Monitors internet status
- Reactive connectivity state
- User notifications

### Navigation: Named Routes

#### Route Structure
```
/ → ContactsScreen (Home)
/contact-detail → ContactDetailScreen
/add-contact → AddEditContactScreen
/edit-contact → AddEditContactScreen
```

#### Benefits
- Centralized route management
- Type-safe navigation
- Easy deep linking support
- Consistent transitions

---

## Firebase Configuration

### Firestore Structure

#### Collection: `contacts`

**Document Structure:**
```json
{
  "name": "John Doe",
  "phone": "+1234567890",
  "email": "john@example.com",
  "isFavorite": 1
}
```

**Field Types:**
- `name`: String (required)
- `phone`: String (required)
- `email`: String (optional, can be null)
- `isFavorite`: Number (1 = true, 0 = false)

**Document ID**: Auto-generated by Firestore

#### Indexes

**Automatic Indexes:**
- `name` (ascending)
- `isFavorite` (ascending)

**Composite Indexes**: None required

### Security Rules

#### Test Mode (Current)
```javascript
allow read, write: if true;
```

#### Production Recommended
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /contacts/{contactId} {
      // Allow authenticated users to read/write their own contacts
      allow read, write: if request.auth != null && 
                           request.auth.uid == resource.data.userId;
      
      // Allow create if authenticated
      allow create: if request.auth != null;
    }
  }
}
```

**Note**: Production rules require Firebase Authentication implementation.

### Firestore Operations

#### Read Operations
- `getAllContacts()`: Fetch all contacts ordered by name
- `getFavoriteContacts()`: Fetch contacts where isFavorite = 1
- `getContactsStream()`: Real-time stream of all contacts

#### Write Operations
- `addContact()`: Create new document
- `updateContact()`: Update existing document
- `deleteContact()`: Delete document by ID

#### Query Optimization
- Ordering by `name` field
- Filtering by `isFavorite` field
- In-memory sorting for favorites

---