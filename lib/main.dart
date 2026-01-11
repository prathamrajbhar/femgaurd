import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Services
import 'services/app_state.dart';

// Utils
import 'utils/app_theme.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/consent_screen.dart';
import 'screens/theme_selection_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cycle_tracking_screen.dart';
import 'screens/symptom_logging_screen.dart';
import 'screens/lifestyle_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/risk_awareness_screen.dart';
import 'screens/doctor_suggestion_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/help_screen.dart';
import 'screens/about_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/symptom_history_screen.dart';
import 'screens/cycle_history_screen.dart';
import 'screens/health_tips_screen.dart';
import 'screens/emergency_contacts_screen.dart';
import 'screens/pcod_awareness_screen.dart';
import 'screens/pcos_awareness_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/daily_logging_screen.dart';
import 'screens/community_screen.dart';
import 'screens/pregnancy_mode_screen.dart';

/// Main entry point for the FemGuard app
/// A Menstrual & Hormonal Health Guardian Application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize app state with local storage
  final appState = AppState();
  await appState.initialize();

  runApp(FemGuardApp(appState: appState));
}

/// Root application widget
class FemGuardApp extends StatelessWidget {
  final AppState appState;

  const FemGuardApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'FemGuard',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeData(appState.selectedTheme),
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/consent': (context) => const ConsentScreen(),
              '/theme-selection': (context) => const ThemeSelectionScreen(),
              '/profile-setup': (context) => const ProfileSetupScreen(),
              '/home': (context) => const HomeScreen(),
              '/cycle-tracking': (context) => const CycleTrackingScreen(),
              '/symptom-logging': (context) => const SymptomLoggingScreen(),
              '/lifestyle': (context) => const LifestyleScreen(),
              '/insights': (context) => const InsightsScreen(),
              '/risk-awareness': (context) => const RiskAwarenessScreen(),
              '/doctors': (context) => const DoctorSuggestionScreen(),
              '/reports': (context) => const ReportsScreen(),
              '/chat': (context) => const ChatScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/profile-edit': (context) => const ProfileEditScreen(),
              '/calendar': (context) => const CalendarScreen(),
              '/help': (context) => const HelpScreen(),
              '/about': (context) => const AboutScreen(),
              '/reminders': (context) => const RemindersScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/symptom-history': (context) => const SymptomHistoryScreen(),
              '/cycle-history': (context) => const CycleHistoryScreen(),
              '/health-tips': (context) => const HealthTipsScreen(),
              '/emergency-contacts': (context) =>
                  const EmergencyContactsScreen(),
              '/pcod-awareness': (context) => const PCODAwarenessScreen(),
              '/pcos-awareness': (context) => const PCOSAwarenessScreen(),
              '/login': (context) => const LoginScreen(),
              '/otp-verification': (context) => const OTPVerificationScreen(),
              '/daily-logging': (context) => const DailyLoggingScreen(),
              '/community': (context) => const CommunityScreen(),
              '/pregnancy-mode': (context) => const PregnancyModeScreen(),
            },
          );
        },
      ),
    );
  }
}
