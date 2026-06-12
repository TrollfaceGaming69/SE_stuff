# MyStudy

## Project Description
MyStudy is a mobile app designed to help students manage learning activities in one integrated platform.
The primary features includes in this app are To-do list, Pomodoro Timer, Calendar, and Music Player

## Project Objectives
- Provides a Todo List feature to record and manage college assignments and personal activities.
- Provides Scheduling features to manage lecture schedules, exams, organizational meetings, and other activities.
- Help students remember deadlines through a notification or reminder system.
- Improve time management efficiency by integrating to-do lists and calendars in one application.
- Reduce the risk of late assignments or missed schedules with an easy-to-understand display.

## Features
### Todo
To record and manage task lists.
Useful for helping users prioritize tasks.

### Calendar
To save important schedules and deadlines.
Useful to help users manage time more regularly.

### Pomodoro Timer
To organize study sessions using the Pomodoro method.
Useful to help improve learning focus.

### Music Support
To provide music as a learning support

## Getting Started
Make sure you have installed these dependencies:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) 
* [Dart SDK](https://dart.dev/get-started/sdk)
* [Firebase CLI](https://firebase.google.com/docs/cli)
* [Android Studio](https://developer.android.com/studio) (for android emulator)

## Installation

### Clone Repository
```sh
git clone [https://github.com/username/nama-repositori.git](https://github.com/username/nama-repositori.git)
cd nama-repositori
```

### Install Dependencies

```sh
flutter pub get
```

### Check Config Status

```sh
flutter doctor -v
```

### Run the App (make sure the emulator is on)

```sh
flutter run
```

## Test Using Browser
Trying to run the app using android emulator can be quite tricky, so if you face difficulties just run it using browser like when inspecting website, just make sure set the inspector aspec ratio is made as similar as possible to phone aspec ratio

### Make Sure VSCode Desktop development with C++ is checked
- Open Visual Studio Installer
- Select Modify on the Visual Studio installation.
- Checked the Desktop development with C++
<img width="418" height="113" alt="Screenshot 2026-06-12 140216" src="https://github.com/user-attachments/assets/2edf9e87-a0a1-4156-8b42-f1b346e4ca8d" />

### Check Config Status

```sh
flutter doctor -v
```

### Run The App (make sure chrome is selected as the device)

```sh
flutter run
```

## Folder Structure
```sh
lib/
├── main.dart                 → Entry point of the app
├── firebase_options.dart     → Firebase configuration
├── assets/images/            → App images
├── pages/                    → UI screens
│   ├── home.dart
│   ├── home_music.dart
│   ├── landing_page.dart
│   ├── login.dart
│   ├── register.dart
│   └── profile.dart
├── services/                 → Business logic (API, auth, etc.)
│   └── auth_service.dart
├── model/                    → Data models
└── view_model/               → App state management
    ├── handle_login.dart
    └── handle_register.dart
```


## Architecture Diagram
<img width="464" height="275" alt="image" src="https://github.com/user-attachments/assets/ab76b985-409c-43cb-a5b8-f6d286eb22e4" />

