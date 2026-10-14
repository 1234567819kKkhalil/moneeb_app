# Moneeb Flutter Project — Architecture Reference

This document captures all established patterns in the project so future feature migrations don't require re-researching the codebase.

---

## 1. Project Structure (Feature-based Clean Architecture)

```
lib/features/<feature_name>/
├── <feature_name>_imports.dart    ← library + all part directives
└── src/
    ├── data/
    │   ├── endpoints/             ← API path constants
    │   ├── models/                ← fromJson models (not entities)
    │   └── repository/            ← abstract + impl
    ├── domain/
    │   ├── entities/              ← UI entities
    │   ├── repositories/          ← abstract repositories
    │   └── use_cases/             ← business logic / use cases
    └── presentation/
        ├── manager/                ← cubit + state files
        ├── pages/                 ← full screen pages
        └── widgets/               ← reusable UI widgets
```

### Part-of Library Pattern
Every file inside `src/` starts with `part of <library_name>;` and is registered in the imports file:
```dart
// In zad_imports.dart
library zad;
import 'package:flutter/material.dart';
// ... other imports

part 'src/data/endpoints/zad_endpoint.dart';
part 'src/data/models/my_model.dart';
part 'src/presentation/manger/my_cubit.dart';
// etc.
```

---

## 2. Colors & Theme

### Access colors via context extension:
```dart
context.appColors.primary.shade500    // Primary green #3E5C56
context.appColors.secondary.shade500  // Gold/wheat #E2CA91
context.appColors.neutral.shade900    // Black
context.appColors.neutral.shade50     // White
context.appColors.danger.shade500     // Red
context.appColors.success.shade500    // Green
context.appColors.appBackgroundColor  // Page background
```

### Color palette (Light mode):
| Category  | shade50 (lightest) | shade500 (main) | shade900 (darkest) |
|-----------|-------------------|-----------------|-------------------|
| Primary   | #E3E8E7           | #172A24         | #070D0B           |
| Secondary | #FBF8EE           | #E2CA91         | #D7AF62           |
| Neutral   | #FFFFFF           | #9C9D9E         | #000000           |

### Dark mode
Colors auto-reverse (shade50↔shade900) via `.dark()` factory.

---

## 3. Text Styles

Access via context extensions:
```dart
context.light      // bodySmall
context.regular    // bodyMedium
context.medium     // bodyLarge
context.semiBold   // titleMedium
context.bold       // titleLarge
context.extraBold  // displaySmall
```

Or via theme:
```dart
context.theme.textTheme.bodyMedium?.copyWith(
  fontWeight: FontWeight.bold,
  fontSize: 12,
  color: context.appColors.neutral.shade900,
)
```

---

## 4. State Management (Cubit + StateBox)

### StateBox (async state wrapper):
```dart
class StateBox<T> {
  StateType type;  // initial, loading, success, failure
  T? data;
  Failure? failure;
  
  // Constructors:
  const StateBox.initial();
  const StateBox.loading();
  const StateBox.success(T data);
  const StateBox.failure(Failure failure);
  
  // Getters:
  bool get isLoading / isSuccess / isFailure / isInitial;
}
```

### State class pattern:
```dart
class MyState extends Equatable {
  final StateBox<List<MyModel>> items;
  // ... other fields
  
  const MyState({required this.items});
  
  factory MyState.initial() => MyState(items: const StateBox.initial());
  
  MyState reduce({StateBox<List<MyModel>>? items}) {
    return MyState(items: items ?? this.items);
  }
  
  @override
  List<Object?> get props => [items];
}
```

### Cubit pattern:
```dart
@injectable  // for DI registration
class MyCubit extends BaseCubit<MyState> {
  final MyRepository _repository;
  
  MyCubit(this._repository) : super(MyState.initial());
  
  Future<void> fetchItems() async {
    emit(state.reduce(items: const StateBox.loading()));
    await collect(
      task: () async {
        final data = await _repository.getItems();
        emit(state.reduce(items: StateBox.success(data)));
      },
      onError: (failure) {
        emit(state.reduce(items: StateBox.failure(failure)));
      },
    );
  }
}
```

### `collect()` function handles:
- Internet connectivity checks
- Error catching & failure conversion
- Unauthorized user dialogs

---

## 5. API / Repository

### Endpoint class:
```dart
class MyEndpoint {
  MyEndpoint._();
  static const String items = "/items";
  static String itemById(String id) => "/items/$id";
}
```

### Repository abstract:
```dart
abstract class MyRepository {
  Future<List<MyModel>> getItems();
}
```

### Repository implementation:
```dart
@LazySingleton(as: MyRepository)
class MyRepositoryImpl implements MyRepository {
  final DioHelper _dioHelper;
  MyRepositoryImpl(this._dioHelper);
  
  @override
  Future<List<MyModel>> getItems() async {
    final response = await _dioHelper.get(MyEndpoint.items);
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => MyModel.fromJson(item))
          .toList();
    }
    return [];
  }
}
```

Base URL is set in `DioHelper` via `Constants.endpoint` (https://api.moneeb.io/api/v1).

---

## 6. Model Pattern

```dart
class MyModel {
  final String id;
  final String title;
  
  MyModel({required this.id, required this.title});
  
  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
    );
  }
  
  // For Skeletonizer loading placeholders:
  factory MyModel.initial() => MyModel(id: '', title: 'جاري التحميل...');
}
```

For localized name fields (ar/en):
```dart
final Map<String, dynamic> name;
String get arabicName => name['ar'] ?? '';
```

---

## 7. Navigation

```dart
// Push a new page:
AppRouteNavigator.push(context, MyPage.routeName, const MyPage());

// Push and get result:
AppRouteNavigator.push<ResultType>(context, MyPage.routeName, const MyPage(),
  onPoppedWithData: (data) { /* handle result */ },
);

// Pop:
AppRouteNavigator.pop(context);

// Push replacement:
AppRouteNavigator.pushReplacement(context, MyPage.routeName, const MyPage());

// Push and remove until:
AppRouteNavigator.pushAndRemoveUntil(context, MyPage.routeName, const MyPage());
```

Each page defines: `static const routeName = '/my-page';`

---

## 8. AppBars

```dart
appBar: AppBars.defaultBar(
  context,
  text: 'عنوان الصفحة',
  useCloseButton: true,
  centerTitle: true,
),
```

---

## 9. Loading States (Skeletonizer)

```dart
BlocBuilder<MyCubit, MyState>(
  builder: (context, state) {
    return Skeletonizer(
      enabled: state.items.isLoading,
      child: ListView.builder(
        itemCount: state.items.isLoading ? 3 : (state.items.data?.length ?? 0),
        itemBuilder: (context, index) {
          final item = state.items.isLoading
              ? MyModel.initial()
              : state.items.data![index];
          return MyWidget(data: item);
        },
      ),
    );
  },
);
```

---

## 10. Dependency Injection

- Uses `injectable` + `get_it`
- Cubits: annotate with `@injectable`
- Repositories: annotate impl with `@LazySingleton(as: AbstractRepo)`
- After adding new injectable classes, run:
  ```
  dart run build_runner build --delete-conflicting-outputs
  ```
- Access instances: `injector<MyClass>()`

---

## 11. Bottom Sheets

```dart
AppBottomSheets.showAppBottomSheet(
  context,
  useCloseButton: false,
  backgroundColor: context.appColors.primary.shade300,
  builder: (context) => MyBottomSheetWidget(),
);
```

---

## 12. Spacing & Dimensions

- Use `Gap` widget or `SizedBox` for spacing
- Common paddings: `EdgeInsets.symmetric(horizontal: 20)` for page content
- `PaddingDimensions.pageHorizontalPadding` from core
- `Dimensions.xxLarge`, `IconDimensions.medium` etc. from design tokens

---

## 13. RTL Support

The app is primarily Arabic RTL. Pages often wrap with `Directionality(textDirection: TextDirection.rtl, ...)` or rely on the global locale settings.

---

## 14. SVG Icons

Use `flutter_svg` and reference paths from `AssetPaths`:
```dart
SvgPicture.asset(AssetPaths.iconMyIcon, width: 16, height: 16);
```
All icon paths must be defined in `lib/core/utils/src/constants/assets_paths/asset_paths.dart`.
Avoid using `Const.icons` or hardcoded strings.
