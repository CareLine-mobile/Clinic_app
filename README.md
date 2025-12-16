# 🏥 Clinic App - Medical Clinic Management System

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)

**A comprehensive clinic management application with seamless appointment booking and modern user experience**

[Features](#-features) • [Screenshots](#-screenshots) • [Quick Start](#-quick-start) • [Architecture](#-project-structure) • [Contributing](#-contributing)

</div>

---

## 📋 Overview

**Clinic App** is an advanced Flutter application designed to simplify the medical appointment booking process. The app provides a modern and user-friendly interface for both patients and doctors.

### 🎯 Main Goals

- Simplify medical appointment booking
- Provide comprehensive information about clinics and doctors
- Enhance patient experience through a smooth interface
- Efficient management of appointments and medical services

---

## ✨ Features

### 🏥 Clinic Management

- **Advanced Image Gallery** - Display clinic images with smooth navigation
- **Comprehensive Information** - Complete details about the clinic and available services
- **Accurate Statistics** - Display visits, bookings, and patient satisfaction rates
- **Review System** - Previous patient reviews with detailed ratings

### 👨‍⚕️ Doctor Management

- **Complete Profiles** - Detailed information about each doctor
- **Available Appointments** - Clear display of free time slots
- **Specializations** - Doctors categorized by specialties
- **Experience & Ratings** - Years of experience and patient reviews

### 📅 Booking System

- **Interactive Calendar** - Easy date selection
- **Real-time Slots** - Display available appointments instantly
- **Quick Booking** - Simple booking process in few steps
- **Notifications** - Reminders for upcoming appointments

### 🎨 User Experience

- **Modern Design** - Material Design 3 with attractive colors
- **Smooth Interface** - Smooth Scrolling and polished Animations
- **Arabic Support** - Full RTL Support
- **Responsive Design** - Compatible with all screen sizes

---

## 📱 Screenshots

<div align="center">

### Clinic Details Screen

| Image Gallery | Clinic Info | Quick Actions |
|:---:|:---:|:---:|
| ![Gallery](https://via.placeholder.com/250x500/0066cc/ffffff?text=Image+Gallery) | ![Info](https://via.placeholder.com/250x500/00cc66/ffffff?text=Clinic+Info) | ![Actions](https://via.placeholder.com/250x500/cc6600/ffffff?text=Quick+Actions) |

### Booking & Reviews Screens

| Calendar & Booking | Doctors List | Reviews |
|:---:|:---:|:---:|
| ![Calendar](https://via.placeholder.com/250x500/6600cc/ffffff?text=Calendar) | ![Doctors](https://via.placeholder.com/250x500/cc0066/ffffff?text=Doctors) | ![Reviews](https://via.placeholder.com/250x500/00cccc/ffffff?text=Reviews) |

</div>

---

## 🚀 Quick Start

### Prerequisites

Before starting, make sure you have installed:

- **Flutter SDK** (3.0 or newer)
- **Dart SDK** (3.0 or newer)
- **Android Studio** or **VS Code**
- **Git**

### 📦 Installation

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/clinic_app.git
cd clinic_app
```

2. **Install packages**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

### 🔧 Setup

#### 1. Firebase Configuration (Optional)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Configure project
flutterfire configure
```

#### 2. Environment Variables Configuration

Create a `.env` file in the root:

```env
API_BASE_URL=https://api.example.com
API_KEY=your_api_key_here
ENABLE_ANALYTICS=true
```

---

## 🏗️ Project Structure

```
lib/
├── 📁 core/                          # Shared core files
│   ├── 🎨 theme/                     # Theme and colors
│   │   ├── colors.dart
│   │   └── theme_data.dart
│   ├── 🛠️ utils/                     # Helper utilities
│   │   ├── app_size.dart
│   │   └── constants.dart
│   └── 🌐 services/                  # Common services
│       ├── api_service.dart
│       └── storage_service.dart
│
├── 📁 features/                      # Main features
│   └── 🏥 clinics/
│       ├── 📊 data/                  # Data layer
│       │   ├── models/
│       │   │   ├── clinic_details_model.dart
│       │   │   ├── doctor_model.dart
│       │   │   └── review_model.dart
│       │   ├── repositories/
│       │   │   └── clinic_repository.dart
│       │   └── datasources/
│       │       ├── clinic_local_datasource.dart
│       │       └── clinic_remote_datasource.dart
│       │
│       ├── 🎯 domain/                # Business logic
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       │
│       └── 🖼️ presentation/          # User interface
│           ├── screens/
│           │   └── clinic_details_screen.dart
│           ├── widgets/
│           │   ├── clinic_image_gallery_widget.dart
│           │   ├── clinic_info_widget.dart
│           │   ├── clinic_statistics_widget.dart
│           │   ├── clinic_services_widget.dart
│           │   ├── clinic_calendar_widget.dart
│           │   ├── doctor_list_widget.dart
│           │   └── reviews_section_widget.dart
│           └── cubits/
│               ├── clinic_cubit.dart
│               └── clinic_state.dart
│
└── 📄 main.dart                      # Entry point
```

### 📐 Architecture

The project follows **Clean Architecture** with layered separation:

```
┌─────────────────────────────────────┐
│     Presentation Layer              │  ← UI & State Management
│     (Screens, Widgets, Cubits)      │
├─────────────────────────────────────┤
│     Domain Layer                    │  ← Business Logic
│     (Entities, Use Cases)           │
├─────────────────────────────────────┤
│     Data Layer                      │  ← Data Management
│     (Models, Repositories, APIs)    │
└─────────────────────────────────────┘
```

---

## 🎨 Technologies Used

### 📚 Main Packages

| Package | Version | Description |
|---------|---------|-------------|
| `flutter_bloc` | ^8.1.3 | State management |
| `flutter_screenutil` | ^5.9.0 | Responsive UI |
| `cached_network_image` | ^3.3.0 | Image caching |
| `intl` | ^0.18.1 | Localization & date support |
| `dio` | ^5.3.3 | HTTP Client |
| `get_it` | ^7.6.4 | Dependency Injection |
| `equatable` | ^2.0.5 | Object comparison |

### 🔨 Development Tools

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
```

---

## 🎯 Key Features in Detail

### 1. 📸 Advanced Image Gallery

```dart
ClinicImageGalleryWidget(
  imageUrls: clinicDetails.imageUrls,
  isOpen: clinicDetails.isOpen,
  isFavorite: clinicDetails.isFavorite,
  onFavoriteToggle: () => _toggleFavorite(),
)
```

**Features:**
- Full-size image display
- Bottom thumbnails for quick navigation
- "+N" indicator for additional images
- Smooth page transitions

### 2. ⚡ Quick Action Cards

```dart
_QuickActionCard(
  icon: Icons.calendar_today,
  title: 'Book Now',
  color: Colors.blue,
  onTap: () => _showBookingSheet(),
)
```

**Available Actions:**
- 📅 Instant Booking
- 🏥 View Services
- ⭐ Read Reviews
- 📍 View Location

### 3. 📅 Smart Booking System

**Steps:**

1. Select date from calendar
2. Automatically display available doctors
3. Choose doctor and time slot
4. Confirm booking

```dart
ClinicCalendarWidget(
  selectedDate: _selectedDate,
  onDateSelected: (date) {
    setState(() => _selectedDate = date);
  },
  accentColor: clinic.accentColor,
)
```

### 4. 📊 Comprehensive Review System

**Includes:**
- Overall average rating
- Star distribution (1-5)
- Patient comments
- Doctor ratings

---

## 🔐 State Management

The project uses **Bloc/Cubit** for state management:

```dart
class ClinicCubit extends Cubit<ClinicState> {
  final ClinicRepository repository;

  ClinicCubit(this.repository) : super(ClinicInitial());

  Future<void> getClinicDetails(String id) async {
    emit(ClinicLoading());
    
    try {
      final clinic = await repository.getClinicById(id);
      emit(ClinicLoaded(clinic));
    } catch (e) {
      emit(ClinicError(e.toString()));
    }
  }
}
```

### Available States:

- `ClinicInitial` - Initial state
- `ClinicLoading` - Loading data
- `ClinicLoaded` - Successfully loaded
- `ClinicError` - Error occurred

---

## 🧪 Testing

### Run Tests

```bash
# All tests
flutter test

# Specific tests
flutter test test/features/clinics/

# With coverage
flutter test --coverage
```

### Test Structure

```
test/
├── unit/                    # Unit tests
├── widget/                  # Widget tests
└── integration/             # Integration tests
```

---

## 📱 Building the App

### Android

```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release --split-per-abi

# Bundle
flutter build appbundle --release
```

### iOS

```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

---

## 🌐 Localization

The app fully supports Arabic with RTL:

```dart
MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('ar', 'EG'),
    Locale('en', 'US'),
  ],
  locale: Locale('ar', 'EG'),
)
```

---

## 🤝 Contributing

We welcome your contributions! To contribute:

1. **Fork the project**
2. **Create a new branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### 📋 Contribution Guidelines

- Follow official Dart/Flutter standards
- Add tests for new features
- Update documentation
- Use Conventional Commits

---

## 🐛 Bug Reports

Found a bug? [Open an Issue](https://github.com/yourusername/clinic_app/issues)

When reporting, please include:
- Clear description of the problem
- Steps to reproduce the issue
- Expected behavior
- Screenshots (if applicable)
- Environment information (Flutter version, OS, etc.)

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Clinic App

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files...
```

---

## 👥 Team

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/yourusername">
        <img src="https://via.placeholder.com/100" width="100px;" alt=""/><br />
        <sub><b>Nour</b></sub>
      </a><br />
      <sub>Lead Developer</sub>
    </td>
    <td align="center">
      <a href="https://github.com/yourusername2">
        <img src="https://via.placeholder.com/100" width="100px;" alt=""/><br />
        <sub><b>Zyad Mohammed</b></sub>
      </a><br />
      <sub>Core Developer</sub>
    </td>
  </tr>
</table>

---

## 📞 Contact

- 📧 Email: nour60@gmail.com, zyadmuhammed05@gmail.com
- 🌐 Website: [www.clinicapp.com](https://www.clinicapp.com)
- 💼 LinkedIn: [Clinic App](https://linkedin.com/company/clinic-app)
- 🐦 Twitter: [@ClinicApp](https://twitter.com/clinicapp)

---

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev) - For the amazing framework
- [Bloc Library](https://bloclibrary.dev) - For state management
- All project contributors

---

## 📈 Roadmap

- [ ] Electronic payment support
- [ ] Chat system with doctors
- [ ] Integration with Apple Health & Google Fit
- [ ] Push notifications
- [ ] Web version
- [ ] Additional language support

---

<div align="center">

**Made with ❤️ in Egypt**

If you like this project, don't forget to give it a ⭐

[⬆ Back to top](#-clinic-app---medical-clinic-management-system)

</div>
