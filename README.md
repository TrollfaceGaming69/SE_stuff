# MyStudy

## Project Description
MyStudy is a mobile app designed to help students manage learning activities in one integrated platform.
The primary features includes in this app are To-do list, Pomodoro Timer, Calendar, and Music Player

## Getting Started
Make sure you have installed these dependencies:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) 
* [Dart SDK](https://dart.dev/get-started/sdk)
* [Firebase CLI](https://firebase.google.com/docs/cli)

## Installation

### Clone Repository
```sh
git clone [https://github.com/username/nama-repositori.git](https://github.com/username/nama-repositori.git)
cd nama-repositori
```

### Install Dependencies

```sh
bash
flutter pub get
```

### Run the App (make sure the emulator is on)

```sh
bash
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

