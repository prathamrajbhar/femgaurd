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

/// Main entry point for the HerHealth app
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
  
  runApp(HerHealthApp(appState: appState));
}

/// Root application widget
class HerHealthApp extends StatelessWidget {
  final AppState appState;
  
  const HerHealthApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'HerHealth',
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
            },
          );
        },
      ),
    );
  }
}
