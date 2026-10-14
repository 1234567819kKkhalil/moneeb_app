# AGENTS.md - Moneeb Flutter Project Guidelines

## Overview
This is a Flutter mobile application using BLoC pattern, dependency injection with injectable/get_it, and code generation for JSON serialization.

---

## Build & Development Commands

### Running the App
```bash
flutter run                                    # Run on connected device
flutter run -d <device_id>                    # Run on specific device
flutter run --release                         # Release build
```

### Code Generation
```bash
dart run build_runner build                   # Generate injectable, json_serializable
dart run build_runner clean                   # Clean generated files
dart run build_runner build --delete-confliction-outputs  # Regenerate with conflict resolution
```

### Linting & Analysis
```bash
flutter analyze                               # Run static analysis
flutter analyze lib/                          # Analyze specific directory
flutter analyze lib/specific_file.dart        # Analyze specific file
```

### Testing
```bash
flutter test                                  # Run all tests
flutter test test/widget_test.dart           # Run single test file
flutter test test/ --name "test_name"        # Run tests matching name pattern
flutter test --reporter expanded             # Detailed test output
flutter test --plain-name "test_name"         # Run tests with exact name match
```

### Build Commands
```bash
flutter build apk --debug                     # Debug APK
flutter build apk --release                 # Release APK
flutter build ios --release                  # iOS release (macOS only)
flutter build bundle                         # App bundle
```

### Localization
```bash
flutter gen-l10n                            # Generate localization files
```

### Assets
```bash
flutter pub run flutter_launcher_icons       # Generate launcher icons
flutter pub run flutter_native_splash:create # Generate splash screen
flutter pub run flutter_native_splash:remove # Remove splash screen
```

---

## Code Style Guidelines

### Imports
- Use relative imports for internal packages when possible
- Group imports: dart, flutter, external packages, internal packages
- Use `part` and `part of` for tightly coupled files (e.g., generated code)
- Avoid wildcard imports (`import '...' show *`)

### Formatting
- Follow Dart convention: 2-space indentation
- Use trailing commas for better formatting
- Keep lines under 80 characters when practical
- Use `const` constructors wherever possible

### Analysis Options
- The project uses `include: package:flutter_lints/flutter.yaml` from analysis_options.yaml
- Enable/disable specific rules using `// ignore: rule_name` or `// ignore_for_file: rule_name`
- Run `flutter analyze` before committing to catch issues

### Types & Type Safety
- Enable strict type checking in analysis_options.yaml
- Use explicit return types for public methods
- Prefer `late` over nullable types when initialization is guaranteed
- Use type inference for local variables when type is obvious
- Avoid `dynamic` except where necessary (e.g., JSON parsing with json_serializable)

### Naming Conventions
- **Files**: snake_case.dart (e.g., `user_repository.dart`)
- **Classes**: PascalCase (e.g., `class UserRepository`)
- **Methods/variables**: camelCase (e.g., `getUser()`, `userList`)
- **Constants**: camelCase with k prefix (e.g., `kDefaultTimeout`)
- **Enums**: PascalCase with singular name (e.g., `enum UserStatus { active, inactive }`)

### BLoC Pattern
- Events should be classes extending a base event class
- States should extend Equatable for value equality
- Use `emit()` only in the mapEventToState method
- Keep BLoC files co-located with their feature
- Use `BlocProvider` at appropriate widget boundaries

### Dependency Injection
- Use `get_it` with injectable for service location
- Annotate injectable classes with `@injectable`
- Use `@injectable` for classes needing injection
- Register factories for transient services, singletons for persistent ones
- Generate code: `dart run build_runner build`

### Error Handling
- Use Result types or sealed classes for expected errors
- Catch specific exceptions, not generic `Exception`
- Always log errors in release builds (use developer logs for debug)
- Show user-friendly error messages via localization

### JSON Serialization
- Use `json_serializable` for model classes
- Annotate with `@JsonKey()` for custom field mapping
- Use `fromJson` and `toJson` factory constructors
- Regenerate after model changes: `dart run build_runner build --delete-confliction-outputs`

### UI Guidelines
- Use Material Design 3 components
- Follow responsive_framework for adaptive layouts
- Use helper widgets from lib/core/ui/helper_widgets/
- Use skeletonizer for loading states
- Extract text to ARB files for localization

### Architecture (Feature-based)
```
lib/
  core/           # Shared utilities, configs, base classes
  features/       # Feature modules (auth, home, settings, etc.)
    <feature>/
      data/      # Repositories, data sources, models
      domain/    # Entities, use cases, repository interfaces
      presentation/ # BLoCs, pages, widgets
```

### Widget Testing
- Use `flutter_test` package
- Use `WidgetTester` for interaction testing
- Mock dependencies with mocktail or similar
- Test one widget per file when possible

---

## Before Committing

Always run these commands before committing:
```bash
flutter analyze lib/     # Run static analysis on lib directory
flutter test             # Run all tests
```

---

## Important Notes

- The project uses Firebase - ensure google-services.json is present for Android
- Environment variables are handled via envied - do not commit .env files
- Some dependencies are commented out in pubspec.yaml - review before enabling
- Use `flutter pub get` after adding new dependencies
- Key dependencies: flutter_bloc, hydrated_bloc, get_it, injectable, dio, json_serializable