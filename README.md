# Eventify Flutter Converted

This project is a Flutter rebuild of the attached Kotlin Eventify app.

## What is included
- Firebase Auth login/signup
- Firestore-backed events, users, registrations
- Profile screen with registered events
- Settings with dark mode + password update
- Admin panel for event creation and registration lookup
- AI chat screen refactored to call a backend endpoint instead of using a hardcoded secret key
- Firebase Messaging topic subscription scaffold

## Important security fix
The original Kotlin project contained a raw OpenAI API key inside the Android app source. This Flutter conversion intentionally does **not** include that key. Set `AppConfig.aiProxyBaseUrl` to your own backend endpoint.

## Setup
1. Install Flutter SDK.
2. From this project folder run:
   ```bash
   flutter pub get
   ```
3. Ensure Android package name / Firebase app registration matches your own setup.
4. Keep the included `android/app/google-services.json` or replace it with your correct one.
5. Run:
   ```bash
   flutter run
   ```

## Notes
- This project was created manually in the container because Flutter SDK was not available there.
- Platform folders such as `ios/`, `web/`, `linux/`, `macos/`, and generated Android Gradle wrappers are not scaffolded here. The Dart app source is complete, but you should run `flutter create .` inside this folder first if you want Flutter to generate any missing platform boilerplate, then keep the `lib/` folder from this project.
