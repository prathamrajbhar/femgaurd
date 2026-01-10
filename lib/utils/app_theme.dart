import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Available color themes for the app
enum ColorTheme {
  rose,
  ocean,
  forest,
  lavender,
  sunset,
}

/// Extension to get theme display info
extension ColorThemeExtension on ColorTheme {
  String get displayName {
    switch (this) {
      case ColorTheme.rose:
        return 'Rose';
      case ColorTheme.ocean:
        return 'Ocean';
      case ColorTheme.forest:
        return 'Forest';
      case ColorTheme.lavender:
        return 'Lavender';
      case ColorTheme.sunset:
        return 'Sunset';
    }
  }

  String get emoji {
    switch (this) {
      case ColorTheme.rose:
        return '🌸';
      case ColorTheme.ocean:
        return '🌊';
      case ColorTheme.forest:
        return '🌿';
      case ColorTheme.lavender:
        return '💜';
      case ColorTheme.sunset:
        return '🌅';
    }
  }

  String get description {
    switch (this) {
      case ColorTheme.rose:
        return 'Soft & feminine';
      case ColorTheme.ocean:
        return 'Calm & serene';
      case ColorTheme.forest:
        return 'Fresh & natural';
      case ColorTheme.lavender:
        return 'Soothing & elegant';
      case ColorTheme.sunset:
        return 'Warm & vibrant';
    }
  }
}

/// Theme color palette for each theme
class ThemeColors {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;
  final Color background;
  final Color accent;

  const ThemeColors({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryDark,
    required this.background,
    required this.accent,
  });

  /// Get colors for a specific theme
  static ThemeColors forTheme(ColorTheme theme) {
    switch (theme) {
      case ColorTheme.rose:
        return const ThemeColors(
          primary: Color(0xFFE8A5B3),
          primaryLight: Color(0xFFFCE4EC),
          primaryDark: Color(0xFFD4899A),
          secondary: Color(0xFF7FCCDF),
          secondaryLight: Color(0xFFE0F7FA),
          secondaryDark: Color(0xFF5BB8D0),
          background: Color(0xFFFFFBFC),
          accent: Color(0xFFFFB5BA),
        );
      case ColorTheme.ocean:
        return const ThemeColors(
          primary: Color(0xFF5DADE2),
          primaryLight: Color(0xFFE3F2FD),
          primaryDark: Color(0xFF2196F3),
          secondary: Color(0xFF80DEEA),
          secondaryLight: Color(0xFFE0F7FA),
          secondaryDark: Color(0xFF4DD0E1),
          background: Color(0xFFFAFDFF),
          accent: Color(0xFF81D4FA),
        );
      case ColorTheme.forest:
        return const ThemeColors(
          primary: Color(0xFF66BB6A),
          primaryLight: Color(0xFFE8F5E9),
          primaryDark: Color(0xFF43A047),
          secondary: Color(0xFFA5D6A7),
          secondaryLight: Color(0xFFE8F5E9),
          secondaryDark: Color(0xFF66BB6A),
          background: Color(0xFFFAFDFA),
          accent: Color(0xFF81C784),
        );
      case ColorTheme.lavender:
        return const ThemeColors(
          primary: Color(0xFFB39DDB),
          primaryLight: Color(0xFFEDE7F6),
          primaryDark: Color(0xFF9575CD),
          secondary: Color(0xFFCE93D8),
          secondaryLight: Color(0xFFF3E5F5),
          secondaryDark: Color(0xFFBA68C8),
          background: Color(0xFFFCFAFF),
          accent: Color(0xFFD1C4E9),
        );
      case ColorTheme.sunset:
        return const ThemeColors(
          primary: Color(0xFFFF8A65),
          primaryLight: Color(0xFFFBE9E7),
          primaryDark: Color(0xFFFF7043),
          secondary: Color(0xFFFFCC80),
          secondaryLight: Color(0xFFFFF8E1),
          secondaryDark: Color(0xFFFFB74D),
          background: Color(0xFFFFFBF9),
          accent: Color(0xFFFFAB91),
        );
    }
  }
}

/// Design System Tokens
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double full = 100;
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
}

/// App color palette - soft pastel colors for a calming health app
/// Now supports dynamic theming through currentTheme
class AppColors {
  static ColorTheme _currentTheme = ColorTheme.rose;
  
  /// Set the current theme
  static void setTheme(ColorTheme theme) {
    _currentTheme = theme;
  }
  
  /// Get the current theme
  static ColorTheme get currentTheme => _currentTheme;
  
  /// Get current theme colors
  static ThemeColors get _colors => ThemeColors.forTheme(_currentTheme);

  // Dynamic primary colors
  static Color get primary => _colors.primary;
  static Color get primaryLight => _colors.primaryLight;
  static Color get primaryDark => _colors.primaryDark;

  // Dynamic secondary colors
  static Color get secondary => _colors.secondary;
  static Color get secondaryLight => _colors.secondaryLight;
  static Color get secondaryDark => _colors.secondaryDark;

  // Dynamic background & accent
  static Color get background => _colors.background;
  static Color get accent => _colors.accent;

  // Status colors (static - shared across themes)
  static const Color statusGreen = Color(0xFF4CAF50);
  static const Color statusYellow = Color(0xFFFFCA28);
  static const Color statusOrange = Color(0xFFFF9800);
  static const Color statusRed = Color(0xFFE53935);

  // Neutral colors (static - shared across themes)
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF1A1C1E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFE0E0E0);

  // Accent colors (static - shared across themes)
  static const Color accentLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFFF9C4);
  static const Color warningDark = Color(0xFFFFB300);

  // Glassmorphism colors
  static Color get glassBackground => Colors.white.withValues(alpha: 0.7);
  static Color get glassBorder => Colors.white.withValues(alpha: 0.5);
  
  // Shadows
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> primaryShadow([double opacity = 0.25]) => [
    BoxShadow(
      color: primary.withValues(alpha: opacity),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

/// Glassmorphism decoration helper
class GlassDecoration {
  static BoxDecoration card({
    double borderRadius = AppRadius.xl,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.glassBackground,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AppColors.glassBorder, width: 1),
      boxShadow: AppColors.softShadow,
    );
  }
  
  static BoxDecoration elevated({
    double borderRadius = AppRadius.xl,
    Color? shadowColor,
  }) {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: (shadowColor ?? AppColors.primary).withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}

/// App theme configuration
class AppTheme {
  /// Get the light theme for the current AppColors settings
  static ThemeData get lightTheme => _buildTheme();

  /// Get theme data for a specific color theme
  static ThemeData getThemeData(ColorTheme theme) {
    AppColors.setTheme(theme);
    return _buildTheme();
  }

  /// Build theme data based on current AppColors
  static ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        secondaryContainer: AppColors.secondaryLight,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.statusRed,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        hintStyle: GoogleFonts.poppins(color: AppColors.textLight),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.primaryLight,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.15),
        valueIndicatorColor: AppColors.primary,
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        valueIndicatorTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: AppColors.border, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textLight,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
