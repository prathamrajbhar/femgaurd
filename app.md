# FemGuard - Menstrual & Hormonal Health Guardian

## 📱 App Overview

**FemGuard** is a comprehensive Flutter-based mobile application designed to help users track and understand their menstrual and hormonal health patterns. The app provides cycle tracking, symptom logging, lifestyle monitoring, AI-powered insights, and health awareness features.

> **Important:** This app is for awareness purposes only and does NOT provide medical diagnoses. Users should always consult healthcare professionals for medical concerns.

---

## 🛠️ Technical Stack

### Framework & Language
- **Framework:** Flutter (Cross-platform)
- **Language:** Dart
- **SDK Version:** ^3.8.1

### Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.2 | State management |
| `table_calendar` | ^3.1.2 | Calendar UI for cycle tracking |
| `fl_chart` | ^0.69.0 | Charts and analytics visualization |
| `shared_preferences` | ^2.3.3 | Local data storage |
| `google_fonts` | ^6.2.1 | Typography |
| `cupertino_icons` | ^1.0.8 | iOS style icons |

### Supported Platforms
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

---

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── dummy_data/
│   └── dummy_data.dart         # Sample/demo data
├── models/
│   ├── chat_message.dart       # Chat message model
│   ├── cycle_model.dart        # Menstrual cycle data model
│   ├── doctor_model.dart       # Doctor information model
│   ├── lifestyle_log.dart      # Lifestyle tracking model
│   ├── symptom_log.dart        # Symptom logging model
│   └── user_model.dart         # User profile model
├── screens/
│   ├── about_screen.dart       # App information
│   ├── calendar_screen.dart    # Full calendar view
│   ├── chat_screen.dart        # AI health companion chat
│   ├── consent_screen.dart     # User consent/disclaimer
│   ├── cycle_history_screen.dart
│   ├── cycle_tracking_screen.dart
│   ├── doctor_suggestion_screen.dart
│   ├── emergency_contacts_screen.dart
│   ├── health_tips_screen.dart
│   ├── help_screen.dart
│   ├── home_screen.dart        # Main dashboard
│   ├── insights_screen.dart    # AI health insights
│   ├── lifestyle_screen.dart   # Lifestyle logging
│   ├── notifications_screen.dart
│   ├── onboarding_screen.dart  # First-time user experience
│   ├── profile_edit_screen.dart
│   ├── profile_screen.dart
│   ├── profile_setup_screen.dart
│   ├── reminders_screen.dart
│   ├── reports_screen.dart     # Analytics & reports
│   ├── risk_awareness_screen.dart
│   ├── settings_screen.dart    # App settings
│   ├── splash_screen.dart      # Launch screen
│   ├── symptom_history_screen.dart
│   ├── symptom_logging_screen.dart
│   └── theme_selection_screen.dart
├── services/
│   └── app_state.dart          # Global state management
├── utils/
│   ├── app_theme.dart          # Theme configuration
│   └── constants.dart          # App constants
└── widgets/
    ├── custom_button.dart      # Reusable button widget
    ├── health_status_badge.dart
    └── slider_input.dart       # Custom slider widget
```

---

## 🎨 Features

### 1. **Cycle Tracking**
- Log period start and end dates
- Interactive calendar with TableCalendar
- View cycle history
- Predict next period date
- Track cycle day

### 2. **Symptom Logging**
- Track pain levels (0-10 scale)
- Track mood levels (0-10 scale)
- Track fatigue/energy levels (0-10 scale)
- Quick symptom selection (Headache, Nausea, Bloating, Cramps, Irritable, Cravings)
- Add custom notes

### 3. **Lifestyle Tracking**
- Sleep hours logging (0-12 hours)
- Stress level tracking (0-10)
- Activity level selection (Sedentary, Light, Moderate, Active, Very Active)

### 4. **AI Health Companion**
- Interactive chat interface
- Pre-defined contextual responses
- Health-related Q&A support
- Always-available virtual assistant

### 5. **Health Insights**
- Pattern-based observations
- Analysis summary
- Educational content
- Health status indicator (Green/Yellow/Orange)

### 6. **Reports & Analytics**
- Cycle length trends (bar charts)
- Period length trends
- Symptom trends over time
- Visual data representation with FL Chart

### 7. **Risk Awareness**
- Health status monitoring
- Orange alert counter system
- Doctor consultation suggestions (after 10 orange alerts)
- Status level explanations

### 8. **Doctor Suggestions**
- List of healthcare providers (demo data)
- Specialty information
- Contact details
- Health summary generation

### 9. **Theming**
Five customizable color themes:
| Theme | Emoji | Description |
|-------|-------|-------------|
| Rose | 🌸 | Soft & feminine |
| Ocean | 🌊 | Calm & serene |
| Forest | 🌿 | Fresh & natural |
| Lavender | 💜 | Soothing & elegant |
| Sunset | 🌅 | Warm & vibrant |

---

## 📊 Data Models

### UserProfile
```dart
- age: int?
- cycleLength: int (default: 28)
- lastPeriodDate: DateTime?
- lifestyleLevel: String (Low/Medium/High)
- hasCompletedOnboarding: bool
- hasAcceptedConsent: bool
```

### CycleData
```dart
- startDate: DateTime
- endDate: DateTime?
- cycleLength: int (default: 28)
- notes: String
- periodLength: int (calculated)
```

### SymptomLog
```dart
- date: DateTime
- painLevel: int (0-10)
- moodLevel: int (0-10)
- fatigueLevel: int (0-10)
- notes: String
- averageSeverity: double (calculated)
```

### LifestyleLog
```dart
- date: DateTime
- sleepHours: double (0-12)
- stressLevel: int (0-10)
- activityLevel: String
```

### ChatMessage
```dart
- id: String
- text: String
- isUser: bool
- timestamp: DateTime
```

### Doctor
```dart
- id: String
- name: String
- specialty: String
- distance: String
- phone: String
- address: String
- rating: double
```

---

## 🔄 State Management

The app uses **Provider** pattern with `ChangeNotifier` for state management through the `AppState` class.

### Key State Properties
- `userProfile` - User information
- `cycleHistory` - List of past cycles
- `symptomLogs` - Symptom tracking history
- `lifestyleLogs` - Lifestyle tracking history
- `chatMessages` - Chat conversation history
- `orangeAlertCount` - Risk awareness counter
- `notificationsEnabled` - Notification settings
- `selectedTheme` - Current color theme

### Computed Properties
- `currentCycleDay` - Current day in cycle
- `nextPeriodDate` - Predicted next period
- `daysUntilNextPeriod` - Days until next period
- `healthStatus` - Current health status (green/yellow/orange)
- `shouldShowDoctorSuggestion` - Based on orange alerts

---

## 💾 Data Persistence

All data is persisted locally using **SharedPreferences**:
- Theme preference
- Notification settings
- User profile (JSON)
- Cycle history (JSON list)
- Symptom logs (JSON list)
- Lifestyle logs (JSON list)
- Chat messages (JSON list)
- Orange alert counter

---

## 🧭 Navigation Routes

| Route | Screen | Description |
|-------|--------|-------------|
| `/splash` | SplashScreen | App launch screen |
| `/onboarding` | OnboardingScreen | First-time user guide |
| `/consent` | ConsentScreen | Terms acceptance |
| `/theme-selection` | ThemeSelectionScreen | Choose app theme |
| `/profile-setup` | ProfileSetupScreen | Initial profile setup |
| `/home` | HomeScreen | Main dashboard |
| `/cycle-tracking` | CycleTrackingScreen | Period tracking |
| `/symptom-logging` | SymptomLoggingScreen | Log symptoms |
| `/lifestyle` | LifestyleScreen | Log lifestyle factors |
| `/insights` | InsightsScreen | AI health insights |
| `/risk-awareness` | RiskAwarenessScreen | Health status info |
| `/doctors` | DoctorSuggestionScreen | Healthcare providers |
| `/reports` | ReportsScreen | Analytics & charts |
| `/chat` | ChatScreen | AI companion |
| `/settings` | SettingsScreen | App settings |
| `/notifications` | NotificationsScreen | Notification management |
| `/profile-edit` | ProfileEditScreen | Edit profile |
| `/profile` | ProfileScreen | View profile |
| `/calendar` | CalendarScreen | Full calendar |
| `/help` | HelpScreen | FAQ & help |
| `/about` | AboutScreen | App info |
| `/reminders` | RemindersScreen | Reminder settings |
| `/symptom-history` | SymptomHistoryScreen | Past symptoms |
| `/cycle-history` | CycleHistoryScreen | Past cycles |
| `/health-tips` | HealthTipsScreen | Health education |
| `/emergency-contacts` | EmergencyContactsScreen | Emergency info |

---

## 🎯 App Constants

```dart
// Default values
defaultCycleLength: 28
defaultPeriodLength: 5
minCycleLength: 21
maxCycleLength: 40

// Risk threshold
orangeAlertThreshold: 10  // Triggers doctor suggestion

// Lifestyle levels
['Low', 'Medium', 'High']

// Activity levels
['Sedentary', 'Light', 'Moderate', 'Active', 'Very Active']
```

---

## 🎨 Design System

### Spacing
- `xs`: 4px
- `sm`: 8px
- `md`: 16px
- `lg`: 24px
- `xl`: 32px
- `xxl`: 48px

### Border Radius
- `sm`: 8px
- `md`: 12px
- `lg`: 16px
- `xl`: 20px
- `xxl`: 28px
- `full`: 100px

### Animation Durations
- `fast`: 150ms
- `normal`: 250ms
- `slow`: 400ms

### Status Colors
- **Green** (`#4CAF50`): Normal health status
- **Yellow** (`#FFCA28`): Monitor status
- **Orange** (`#FF9800`): Consider consultation
- **Red** (`#E53935`): Alert status

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.8.1
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mobileapp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build Commands

```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web

# Windows
flutter build windows
```

---

## 📋 User Flow

1. **First Launch**
   - Splash Screen → Onboarding → Consent → Theme Selection → Profile Setup → Home

2. **Regular Use**
   - Splash Screen → Home Dashboard

3. **Main Navigation** (Bottom Nav)
   - Home (Dashboard)
   - Cycle (Tracking Calendar)
   - Chat (AI Companion)
   - Profile (Settings)

---

## ⚠️ Disclaimer

This app is designed for **health awareness only** and includes the following important notices:

- ❌ Does NOT provide medical diagnosis
- ✅ All insights are for awareness purposes only
- ✅ User maintains complete control over their data
- ❌ No data is shared with third parties
- ✅ Always consult healthcare professionals for medical concerns

---

## 📄 License

This is a private project developed for PDPU Hackathon.

---

## 👥 Contributors

Developed for PDPU Hackathon 2026

---

*Last Updated: January 10, 2026*
