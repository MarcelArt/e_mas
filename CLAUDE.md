# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

E-Mas is a Flutter mobile app for tracking gold investment portfolios. It allows users to add gold purchases (UBS, Antam, or other brands), track buy prices, and monitor current market values using live gold price data.

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

## Architecture

### Layer Structure
- `lib/api/` - API clients (Dio-based) for external services
- `lib/models/` - Data models with Hive serialization
- `lib/repos/` - Repository layer for data operations (Hive box access)
- `lib/views/` - Screen-level widgets (routes)
- `lib/widgets/` - Reusable UI components
- `lib/utils/` - Helper functions (currency formatting, etc.)
- `lib/seed/` - Development data seeding

### Key Patterns

**Hive Local Storage**: Collections are stored in a Hive box named `'collections'`. The box is initialized in `main.dart` with `Hive.registerAdapter(CollectionAdapter())` before opening.

**ValueListenableBuilder**: Used throughout to reactively update UI when Hive box data changes. Pattern:
```dart
ValueListenableBuilder(
  valueListenable: collectionsBox.listenable(),
  builder: (context, value, child) { /* ... */ }
)
```

**API Response Wrapper**: `ApiResponse<T>` provides a generic wrapper with `items`, `isSuccess`, and `message` fields. Use `.fromJson()` with a converter function for typed responses.

**Brand-Based Price Lookup**: Gold prices are fetched from external API (`https://aimas.bangmarcel.art/api/gold-price/latest`) and mapped by brand (UBS/Antam) and weight (gram) as string keys.

## App Configuration

- **Application ID**: `art.bangmarcel.e_mas`
- **Namespace**: `art.bangmarcel.e_mas`
- **Routes**: `/` (HomeView), `/add-gold` (AddGoldView)
- **Signing**: Release builds use keystore from `key.properties` (not in repo)
