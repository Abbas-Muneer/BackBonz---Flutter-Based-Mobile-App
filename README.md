# BackBonz

BackBonz is a Flutter + Firebase MVP for teenagers with scoliosis who need to wear corrective braces for long daily periods. The app focuses on one clear workflow: sign in, track a brace session with a timestamp-based timer, and review today's completed sessions.

## Features

- Email/password sign up and login with Firebase Authentication
- Auth-aware app startup with a splash/auth gate flow
- Timestamp-based wear timer with start, pause, resume, and stop
- Cloud Firestore session storage under `users/{userId}/sessions/{sessionId}`
- Today's sessions list with immediate refresh after stop
- Today's total wear-time summary
- User-scoped Firestore security rules
- Lightweight tests for validators, formatting, and timer logic

## Why timestamp-based timing

The timer is not driven by a naive `seconds++` counter. Instead, it stores real timestamps and derives elapsed time from:

- `sessionStartTime`
- `initialSessionStartTime`
- `accumulatedDuration`

This makes the timer easier to explain and more reliable when pausing, resuming, or handling UI rebuilds. A periodic timer is only used to refresh the display. It is not the source of truth.

## Tech stack

- Flutter
- Firebase Authentication
- Cloud Firestore
- Provider
- intl

## Project structure

```text
lib/
  app.dart
  firebase_options.dart
  main.dart
  core/
    theme/
    utils/
  models/
  providers/
  screens/
  services/
  widgets/
```

## Firebase services used

- Firebase Auth for email/password login and sign up
- Cloud Firestore for brace wear sessions

## Firestore schema

Recommended structure:

```text
users/{userId}/sessions/{sessionId}
```

Each session document contains:

```json
{
  "userId": "uid",
  "startTime": "Timestamp",
  "endTime": "Timestamp",
  "durationSeconds": 5400,
  "dateKey": "2026-03-26",
  "createdAt": "server timestamp"
}
```

## Security

Firestore rules in [firestore.rules](/c:/Users/MSII/Desktop/BackBonz---Flutter-Based-Mobile-App/firestore.rules) ensure:

- unauthenticated users cannot access private data
- users can only read and write session documents under their own UID path

## Setup

1. Install Flutter and connect a device or emulator.
2. Create a Firebase project.
3. Enable Email/Password in Firebase Authentication.
4. Create a Cloud Firestore database.
5. Run `flutterfire configure`.
6. Replace the placeholder [firebase_options.dart](/c:/Users/MSII/Desktop/BackBonz---Flutter-Based-Mobile-App/lib/firebase_options.dart) with the generated file if needed.
7. Deploy [firestore.rules](/c:/Users/MSII/Desktop/BackBonz---Flutter-Based-Mobile-App/firestore.rules).
8. Run `flutter pub get`.
9. Run `flutter run`.

## Running in Firebase Studio / locally

The repository includes a compile-safe placeholder `firebase_options.dart` so the project structure is complete. To use real auth and Firestore, generate real FlutterFire options for your Firebase project before running the app.

## Interview walkthrough talking points

- Flutter is a good fit because one codebase covers mobile platforms cleanly and the widget tree is easy to demo live.
- Firebase Auth keeps account handling simple while showing a real production service.
- Firestore is structured by user path, which keeps reads scoped and security rules straightforward.
- Provider keeps state management clear without introducing heavy abstraction.
- The timer logic is timestamp-based, which is safer than incrementing counters.
- A small live change is easy to demo, such as adding a daily goal badge or a delete action for a session card.

## Tradeoffs

- The app keeps state management intentionally simple for interview readability.
- Sessions are queried by a `dateKey` string to make today's filtering easy to explain.
- Firebase configuration values are not committed here because they depend on your Firebase project.

## Possible future improvements

- Daily goal progress ring
- Weekly and monthly analytics
- Local reminders and notifications
- Streaks and encouragement messages
- Session editing and deletion

## Testing

Run:

```bash
flutter test
```

The test suite covers:

- validators
- duration formatting helpers
- timestamp-based timer behavior
