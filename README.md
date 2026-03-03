# Evencir - Fitness Dashboard App

A comprehensive Flutter fitness dashboard application built as an interview test task, featuring state management with BlocPattern, responsive UI design, and comprehensive test coverage.

---

## 📦 Dependencies Used & Why

| Package | Version | Purpose |
|---------|---------|---------|
| **flutter_bloc** | ^8.1.6 | State management using BLoC pattern for reactive UI updates |
| **bloc** | ^8.1.4 | Core BLoC library providing Bloc & Cubit abstractions |
| **flutter_svg** | ^2.2.2 | Renders SVG icons for crisp, scalable graphics |
| **go_router** | ^13.2.0 | Modern routing and navigation management |
| **provider** | ^6.1.5 | Provides access to BLoC instances across the widget tree |
| **equatable** | ^2.0.8 | Simplifies equality comparisons for BLoC states |
| **intl** | ^0.20.2 | Internationalization and date/time formatting |
| **scrollable_positioned_list** | ^0.3.8 | Custom scrolling with precise position control for week view |
| **cupertino_icons** | ^1.0.8 | iOS-style icons used throughout the app |
| **bloc_test** | ^9.1.0 | *(Dev)* Unit testing framework for BLoC logic |
| **golden_toolkit** | ^0.15.0 | *(Dev)* Multi-device golden testing for visual regression |
| **flutter_test** | SDK | *(Dev)* Widget testing framework |

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors_extension.dart       # Material Design 3 color system
│   │   └── app_theme.dart                  # Light & dark theme definitions
│   └── utils/
│       └── app_icons.dart                  # SVG icon asset management
│
├── features/
│   ├── home/
│   │   ├── bloc/
│   │   │   ├── home_cubit.dart             # State management for home view
│   │   │   └── home_state.dart             # Home feature state definitions
│   │   ├── pages/
│   │   │   └── home_view.dart              # Main dashboard view (StatefulWidget for hourly updates)
│   │   └── widgets/
│   │       ├── calories_card.dart          # Macro tracking card with auto-scaling text
│   │       ├── hydration_card.dart         # Water intake tracker
│   │       ├── weight_card.dart            # Weight display card
│   │       ├── workout_card.dart           # Exercise history card
│   │       └── week_view.dart              # Weekly activity overview
│   │
│   ├── mood/
│   │   ├── bloc/
│   │   │   ├── mood_cubit.dart             # Mood tracking state
│   │   │   └── mood_state.dart
│   │   ├── pages/
│   │   │   └── mood_view.dart              # Mood rating interface
│   │   └── widgets/
│   │       └── mood_wheel.dart             # Circular mood selector
│   │
│   └── plan/
│       ├── bloc/
│       │   ├── plan_cubit.dart             # Workout plan management
│       │   └── plan_state.dart
│       ├── pages/
│       │   └── plan_view.dart              # Weekly plan display
│       └── widgets/
│           └── workout_list_tile.dart      # Individual workout item
│
├── tab/
│   ├── cubit/
│   │   ├── date_cubit.dart                 # Global date selection state
│   │   └── date_state.dart
│   └── pages/
│       └── tab_view.dart                   # Bottom navigation wrapper
│
├── widgets/
│   ├── section_header.dart                 # Reusable section title component
│   ├── week_calendar.dart                  # Week date picker widget
│   └── custom_bottom_nav.dart              # Bottom navigation bar
│
└── main.dart                               # App entry point with BlocProviders

test/
├── features/
│   ├── home/
│   │   ├── cubit/
│   │   │   └── date_cubit_test.dart        # Unit tests for date logic
│   │   └── view/
│   │       └── home_view_test.dart         # Widget tests for home view
│   ├── mood/
│   │   ├── cubit/
│   │   │   └── mood_cubit_test.dart        # Mood state tests
│   │   └── view/
│   │       └── mood_view_test.dart         # Mood UI tests
│   └── plan/
│       ├── cubit/
│       │   └── plan_cubit_test.dart        # Plan logic tests
│       └── view/
│           └── plan_view_test.dart         # Plan view tests
│
└── goldens/
    ├── home_view_golden_test.dart          # Visual regression: HomeView (light/dark)
    ├── mood_view_golden_test.dart          # Visual regression: MoodView (light/dark)
    └── plan_view_golden_test.dart          # Visual regression: PlanView (light/dark)
```

### Key Architecture Patterns

- **BLoC Pattern**: All state management through Bloc/Cubit for scalability
- **Clean Architecture**: Separation of concerns with features, core, and widgets layers
- **Responsive UI**: FittedBox for auto-scaling text, responsive layouts across devices
- **Material Design 3**: Modern Material Design with light/dark theme support
- **Real-time Updates**: Hourly timer mechanism for dynamic day/night icon switching

---

## 🎨 App Screenshots

📷 **Main Dashboard, Mood Tracker, Weekly Plan Views**

[View Screenshots](https://drive.google.com/drive/folders/YOUR_FOLDER_ID) *(Link to be added)*

---

## 🎬 App Demo Video

Watch a demonstration of the app's full functionality:

[Watch App Demo Video](https://drive.google.com/file/d/YOUR_VIDEO_ID/view) *(Link to be added)*

---

## 📥 Download APK

Download the release APK for testing on Android devices:

[Download APK](https://drive.google.com/file/d/YOUR_APK_ID/view) *(Link to be added)*

**Build Info**: 
- Flutter SDK: ^3.7.0
- Compiled with: Material Design 3
- Min Android API: 21

---

## ✅ Test Coverage

- **25 Unit Tests**: Core business logic (DateCubit, MoodCubit, PlanCubit)
- **27 Widget Tests**: UI interaction and state binding
- **19 Golden Tests**: Visual regression across multiple device sizes and themes (light/dark)

Run tests with:
```bash
flutter test                    # Run all tests
flutter test --update-goldens   # Update golden references
```

---

## 🚀 Getting Started

1. **Install Flutter SDK** (^3.7.0)
2. **Clone the repository**
3. **Get dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the app**:
   ```bash
   flutter run
   ```

---

## 📋 Key Features

✨ **Dashboard**: Real-time fitness metrics with dynamic day/night icons  
🎯 **Mood Tracking**: Interactive mood wheel with state persistence  
📅 **Weekly Plans**: Organized workout schedule with swipeable calendar  
🌙 **Dark Mode**: Full Material Design 3 theme support  
♿ **Responsive**: Optimal UI across phones, tablets, and different orientations  
🧪 **Thoroughly Tested**: Unit, widget, and golden tests with comprehensive coverage

---

## 📝 Notes

This project demonstrates production-quality Flutter development practices including:
- Proper BLoC state management architecture
- Comprehensive test coverage (unit, widget, visual regression)
- Clean code structure following SOLID principles
- Material Design 3 implementation with theme system
- Performance optimization (hourly timers, text scaling)
