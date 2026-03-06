# E-Mas

A Flutter mobile app for tracking gold investment portfolios. Track your UBS, Antam, or other brand gold purchases and monitor current market values with live gold price data.

## Development Commands

### FVM (Flutter Version Management)
The project uses FVM to pin Flutter version to 3.38.7. Always prefix Flutter commands with `fvm`:
```bash
fvm flutter pub get
fvm flutter run
fvm flutter build apk
fvm flutter build appbundle
```

### Code Generation
Hive adapters are generated using build_runner. Run after modifying models with `@HiveType` annotations:
```bash
fvm flutter pub run build_runner build
```

### Testing
```bash
fvm flutter test
```

## App Theme

E-Mas uses a centralized theme system in [`lib/utils/app_theme.dart`](lib/utils/app_theme.dart) for consistent styling across the app.

### Import
```dart
import 'package:e_mas/utils/app_theme.dart';
```

### Colors
| Constant | Value | Usage |
|----------|-------|-------|
| `AppColors.background` | #0F0F1A | Main background |
| `AppColors.cardBackground` | #1A1A2E | Card backgrounds |
| `AppColors.gold` | #FFD700 | Primary accent/gold |
| `AppColors.textPrimary` | White | Primary text |
| `AppColors.textSecondary` | #9CA3AF | Secondary text |
| `AppColors.error` | #DC2626 | Error states |

### Text Styles
```dart
AppTextStyles.headingLarge   // 24px, extra bold
AppTextStyles.headingMedium  // 18px, bold
AppTextStyles.bodyLarge      // 14px, medium
AppTextStyles.bodyMedium     // 13px, regular
AppTextStyles.priceLarge     // 28px, bold for prices
```

### Decorations
```dart
// Gradient card
AppDecorations.cardDecoration()

// Plain card
AppDecorations.cardDecorationPlain()

// Gold gradient (for buttons/badges)
AppDecorations.goldGradientDecoration()

// Input field
AppDecorations.inputDecoration(hintText: 'Enter value')
```

### Buttons
```dart
// Gold primary button
ElevatedButton(
  style: AppButtonStyles.goldButton,
  onPressed: () {},
  child: Text('Submit'),
)
```

### Spacing
```dart
AppSpacing.xs  // 4px
AppSpacing.sm  // 8px
AppSpacing.md  // 16px
AppSpacing.lg  // 24px
AppSpacing.xl  // 32px
```

## Architecture

### Layer Structure
- `lib/api/` - API clients (Dio-based) for external services
- `lib/models/` - Data models with Hive serialization
- `lib/repos/` - Repository layer for data operations (Hive box access)
- `lib/views/` - Screen-level widgets (routes)
- `lib/widgets/` - Reusable UI components
- `lib/utils/` - Helper functions (currency formatting, theme, etc.)
- `lib/seed/` - Development data seeding

### Key Patterns

**Hive Local Storage**: Collections are stored in a Hive box named `'collections'`. The box is initialized in `main.dart` with `Hive.registerAdapter(CollectionAdapter())` before opening.

**ValueListenableBuilder**: Used throughout to reactively update UI when Hive box data changes.

**API Response Wrapper**: `ApiResponse<T>` provides a generic wrapper with `items`, `isSuccess`, and `message` fields.

**Brand-Based Price Lookup**: Gold prices are fetched from external API and mapped by brand (UBS/Antam) and weight (gram) as string keys.

## App Configuration

- **Application ID**: `art.bangmarcel.e_mas`
- **Namespace**: `art.bangmarcel.e_mas`
- **Routes**: `/` (HomeView), `/add-gold` (AddGoldView)
- **Signing**: Release builds use keystore from `key.properties` (not in repo)
