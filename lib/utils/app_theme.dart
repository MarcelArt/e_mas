import 'package:flutter/material.dart';

/// App-wide theme constants for E-Mas
///
/// Usage:
/// ```dart
/// import 'package:e_mas/utils/app_theme.dart';
///
/// Container(
///   color: AppColors.background,
///   child: Text(
///     'Hello',
///     style: AppTextStyles.heading,
///   ),
/// )
/// ```
class AppColors {
  AppColors._();

  // Background colors
  static const Color background = Color(0xFF0F0F1A);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color cardBackgroundAlt = Color(0xFF16213E);

  // Border colors
  static const Color border = Color(0xFF2D2D44);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF6B7280);

  // Accent colors
  static const Color gold = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFFFA500);

  // Status colors
  static const Color success = Colors.green;
  static const Color error = Color(0xFFDC2626);
  static const Color errorBackground = Color(0xFF3F1A1A);
  static const Color info = Color(0xFF3B82F6);

  // Shadow colors
  static Color shadow(BuildContext context) {
    return Colors.black.withValues(alpha: 0.3);
  }

  static Color shadowLight(BuildContext context) {
    return Colors.black.withValues(alpha: 0.05);
  }
}

class AppTextStyles {
  AppTextStyles._();

  // Heading styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  // Label styles
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // Price/value styles
  static const TextStyle priceLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle priceMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );
}

class AppDecorations {
  AppDecorations._();

  // Cached decorations for better performance
  static final BoxDecoration _cachedCardDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.cardBackground,
        AppColors.cardBackgroundAlt,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.border,
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF000000).withValues(alpha: 0.3),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  static final BoxDecoration _cachedCardDecorationPlain = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.border,
      width: 1,
    ),
  );

  // Card decorations
  static BoxDecoration cardDecoration({Color? color}) {
    if (color == null) return _cachedCardDecoration;
    return _cachedCardDecoration.copyWith(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color, AppColors.cardBackgroundAlt],
      ),
    );
  }

  static BoxDecoration cardDecorationPlain({Color? color}) {
    if (color == null) return _cachedCardDecorationPlain;
    return _cachedCardDecorationPlain.copyWith(color: color);
  }

  // Input decoration
  static InputDecoration inputDecoration({
    required String hintText,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodySmall,
      filled: true,
      fillColor: AppColors.cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gold),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      errorStyle: TextStyle(color: AppColors.error),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  // Gold gradient decoration
  static BoxDecoration goldGradientDecoration({double radius = 20}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.gold,
          AppColors.goldDark,
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.gold.withValues(alpha: 0.4),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}

class AppButtonStyles {
  AppButtonStyles._();

  // Gold primary button
  static ButtonStyle goldButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.gold,
    foregroundColor: AppColors.background,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
  );

  // Gold small button
  static ButtonStyle goldButtonSmall = ElevatedButton.styleFrom(
    backgroundColor: AppColors.gold,
    foregroundColor: AppColors.background,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 0,
  );

  // Danger button (remove/delete)
  static ButtonStyle dangerButton = TextButton.styleFrom(
    foregroundColor: AppColors.error,
  );
}

class AppBorderRadius {
  AppBorderRadius._();

  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xlarge = 20;
  static const double round = 100;
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Extension methods for quick access to theme values
extension AppColorsExtension on BuildContext {
  // Quick access to colors
  Color get background => AppColors.background;
  Color get cardBackground => AppColors.cardBackground;
  Color get gold => AppColors.gold;
}
