# Project SOCRATES

A Flutter-based mobile application that supports real-time geofencing, user authentication, and data collection, designed to provide seamless functionality with intuitive features.

## Features

- **Authentication**: Secure login and registration using Firebase Authentication.
- **Geofencing**: Dynamically check user location within predefined boundaries.
- **Real-time Database**: Store and fetch data using Firebase Firestore.
- **Dark Mode**: Mobile app supports dark mode for better usability.
- **Releases**: Automatically publish APK files to a public repository as GitHub Releases.

## Tools and Technologies

- **Frontend**: Flutter, Dart
- **Backend**: Firebase Firestore, Firebase Authentication
- **Version Control**: Git, GitHub
- **Build System**: GitHub Actions
- **Design**: Adobe Illustrator

## Installation

Follow these steps to set up the project locally:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/HimalThapaMagar/Public-SOCRATES.git
   cd socrates
   ```

2. **Install Flutter Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Add your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files to the respective directories.
   - Ensure `firebase_options.dart` is generated locally using `flutterfire configure`.

4. **Run the App**:
   ```bash
   flutter run
   ```

## Usage

### Building the APK

To build the release APK, run:
```bash
flutter build apk --release
```
The generated APK will be located in `build/app/outputs/flutter-apk/`.


## Folder Structure

```plaintext
lib/
├── main.dart           # Entry point of the application
├── firebase_options.dart # Firebase configuration (local only)
├── pages/
│   ├── add_data_page.dart  # Handles data input and geofence addition
│   └── ...                # Other app pages
├── services/
│   ├── geofence_service.dart # Geofence logic and validations
│   └── ...                  # Other services
build/                     # APK and build artifacts
``` 

## Testing

Manual testing was employed to validate:
- UI/UX functionality across modules.
- Geofencing logic and accuracy.
- Firebase integration for data storage and authentication.

Automated testing is planned for future iterations.

## Future Improvements

- Implement automated testing for geofencing and Firebase integrations.
- Optimize APK release workflow for faster deployments.

## License

This project is licensed under the Creative Commons Attribution-NonCommercial (CC BY-NC) license.

## Contributing

We welcome contributions! Please fork the repository and submit a pull request for review.
