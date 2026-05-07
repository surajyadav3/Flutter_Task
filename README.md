# Activity Tracker

A Flutter mobile app that lets users track their daily fitness activities — steps walked, calories burned, and water intake. Data is stored in the cloud using Firebase so it stays saved even after closing the app.

---

## Features

- **Login & Register** — Create an account or log in with email and password
- **Dashboard** — See today's total steps, calories, and water at a glance
- **Track Activity** — Log steps, calories, and water intake with timestamp
- **History** — View all past activity entries, pull down to refresh
- **Profile** — Save your name, age, weight, and daily step goal
- **Logout** — Safely sign out, each user only sees their own data

---

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | UI framework to build the Android app |
| Dart | Programming language used with Flutter |
| Firebase Authentication | User login and registration |
| Cloud Firestore | Cloud database to store activities and profiles |
| GetX | State management, navigation, and snackbars |

---

## Project Structure

```
lib/
├── main.dart                        # App entry point, Firebase init, auth check
├── controllers/
│   ├── auth_controller.dart         # Login, register, logout logic
│   ├── activity_controller.dart     # Save and fetch activity data
│   └── profile_controller.dart      # Save and fetch user profile
├── models/
│   ├── activity_model.dart          # Data structure for activity entries
│   └── profile_model.dart           # Data structure for user profile
└── screens/
    ├── login_screen.dart            # Login and register screen
    ├── home_screen.dart             # Main screen with bottom navigation
    ├── tracking_screen.dart         # Screen to log new activity
    ├── history_screen.dart          # Screen to view past activities
    └── profile_screen.dart          # Screen to manage profile
```

---

## How It Works

1. User opens the app — Firebase checks if already logged in
2. If not logged in, Login screen appears
3. After login, Home screen shows today's totals fetched from Firestore
4. User goes to Track tab, enters steps/calories/water, taps Save
5. Data is saved to Firestore and home dashboard updates instantly
6. History tab shows all past entries sorted by newest first
7. Profile tab lets user save personal details and step goal

---

## Setup Instructions

> To run this project locally you need to connect your own Firebase project.

1. Clone the repo
   ```
   git clone https://github.com/surajyadav3/Flutter_Task.git
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)

4. Enable **Email/Password** under Authentication → Sign-in methods

5. Create a **Firestore Database** and set rules to authenticated users only

6. Download `google-services.json` and place it in `android/app/`

7. Run `flutterfire configure` to generate `lib/firebase_options.dart`

8. Run the app
   ```
   flutter run
   ```

---

## Screenshots

<img width="200" height="400" alt="Screenshot 2026-05-07 180443" src="https://github.com/user-attachments/assets/eb10653d-cdef-41d5-912c-2d7562bb5566" />
<img width="200" height="400" alt="Screenshot 2026-05-07 180408" src="https://github.com/user-attachments/assets/567bf423-8bb0-4c11-a0ae-42662e0a61b2" />
<img width="200" height="400" alt="Screenshot 2026-05-07 180401" src="https://github.com/user-attachments/assets/31017c82-2f0a-40c0-a6a9-d6738c2e1949" />
<img width="200" height="400" alt="Screenshot 2026-05-07 180353" src="https://github.com/user-attachments/assets/65a93fe7-833a-4da4-8077-99be624535a5" />
<img width="200" height="400" alt="Screenshot 2026-05-07 180322" src="https://github.com/user-attachments/assets/7a3edd37-4779-47ae-a169-4f51db13d0a8" />


---

## Developer

**Suraj Yadav**  
