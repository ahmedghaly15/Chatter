# Chatter-App
A Flutter app uses real-time messaging application that allows users to communicate with each other instantly. This app is designed with a sleek and user-friendly interface, making it easy for anyone to use. The app leverages Firebase Realtime Database to ensure that messages are delivered instantly and reliably.

## Contents

- [Preview](#preview)
- [App Structure](#app-structure)
- [Features](#features)
- [Getting Started](#getting-started)

## Preview

<div style="display: flex" > 
  <img style="display: inline-block" src="https://github.com/ahmedghaly15/Chatter-App/assets/108659381/eac2ed51-5406-4b84-b44c-045d65b053f7" width= "300" height = "600"/>
  
</div>

## App Structure

```
lib 
├── cubit
│
├── models
│
├── network
│   ├── local
│   └──── cache_helper.dart
│
├── screens
│   ├── auth 
│   └──── cubit
│   └──── auth_screen.dart
│   │
│   ├── splash_screen.dart
│   │
│   ├── home_screen.dart
│   │
│   ├── chat_details_screen.dart
│   │
│   └── profile_screen.dart
│
├── services
│   ├── themes
│   └── theme_services
│
├── shared
│   ├── components
│   ├── bloc_observer.dart
│   └── constants.dart
│
├── firebase_options.dart
│
└── main.dart

```

## Features
- `Firebase authentication`: The app uses Firebase Authentication to provide secure user authentication and authorization.
- `Cloud firestore1`: The app uses Firebase Cloud Firestore to store users profile images and images they send to each other in chats.
- `Dark theme`: The app supports a dark theme, which provides a comfortable viewing experience in low-light environments.
- `Real-time messaging`: The app utilizes Firebase Realtime Database to enable real-time messaging, allowing users to communicate with each other instantly.
- `Search`: allows users to find specific conversations or messages within a chat by entering relevant keywords or phrases.
- `Profile customization`: Users have the ability to set their profile image and bio, allowing them to personalize their account and make it more recognizable to other users.

## Getting Started

This is a simple Flutter chat app help users to communicate and connect with each other.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
