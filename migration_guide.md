# 🚀 Guide: Migrating Legacy Features to Clean Architecture

هذا الدليل يوضح الخطوات القياسية المتبعة في المشروع الحالي لتحويل أي ميزة (Feature) من النظام القديم (باستخدام GetX والواجهات القديمة) إلى النظام الجديد (باستخدام Clean Architecture و Cubit/Bloc). يمكن استخدام هذا الملف كمرجع لنسخ أي ميزة مستقبلية.

---

## 1. الهيكل الأساسي للمجلد (Folder Structure)
عند نقل أي ميزة جديدة (مثلاً `zad`)، يتم إنشاء المجلد داخل `lib/features/` وتقسيمه بالشكل التالي:

```text
lib/features/zad/
├── zad_imports.dart                  # ملف التجميع (Barrel File) لتصدير جميع ملفات الميزة
└── src/
    ├── domain/                       # طبقة المجال (Domain Layer)
    │   └── entities/                 # بيانات وهمية أو كلاسات النماذج (Models & Dummy Data)
    ├── presentation/                 # طبقة العرض (UI Layer)
    │   ├── manger/                   # إدارة الحالة (State Management)
    │   │   ├── zad_cubit.dart        # الكيوبت (يستبدل GetxController)
    │   │   └── zad_state.dart        # حالات الكيوبت (يستخدم Equatable)
    │   ├── pages/                    # الشاشات الرئيسية
    │   │   └── zad_page.dart         # صفحة الميزة الرئيسية
    │   └── widgets/                  # المكونات الإضافية (Widgets)
    │       ├── zad_widget_1.dart     
    │       └── zad_widget_2.dart
```

---

## 2. الخطوات العملية للتحويل (Migration Steps)

### الخطوة الأولى: تحويل النماذج (Models & Dummy Data)
- **النظام القديم:** كنت تستخدم ملفات `model` و `constants` وملفات منفصلة للبيانات الوهمية.
- **النظام الجديد:** أنشئ ملف `[feature_name]_dummy_data.dart` في مجلد `entities`، وضع فيه كلاسات النماذج (Models) وأي `Constants` مخصصة لهذه الميزة (مثل الصور الوهمية والنصوص). 

### الخطوة الثانية: تحويل إدارة الحالة (State Management)
- **النظام القديم:** الكلاس يرث من `GetxController`، ويستخدم المتغيرات بشكل مباشر ويتم التحديث عبر `update()`.
- **النظام الجديد:** 
  1. أنشئ ملف `[feature_name]_state.dart` يحتوي على متغيرات الشاشة مجمعة في صنف يرث من `Equatable`.
  2. قم بإنشاء دالة `copyWith` لتحديث الحالة.
  3. أنشئ ملف `[feature_name]_cubit.dart` واستبدل أي دالة `onInit` بـ `init()` يتم المناداة عليها كالتالي: `..init()` عند إنشاء الكيوبت. كل عملية تغيير تستخدم `emit(state.copyWith(...))`.

### الخطوة الثالثة: تجهيز ملف الواردات (Barrel File - Imports)
- يتم إنشاء ملف باسم `[feature_name]_imports.dart` بداخل مجلد الميزة مباشرةً.
- يتم تعريف الحزمة `library [feature_name];`.
- قم بدمج جميع الملفات الخاصة بالميزة باستخدام كلمة `part`: `part 'src/presentation/...';`.
- سيتم استخدام `part of [feature_name];` أعلى جميع ملفات الشاشات والكيوبت والموديل.

### الخطوة الرابعة: تحويل واجهات المستخدم (UI Translation)
- **من `GetBuilder` إلى `BlocBuilder`**: استبدل استماع GetX بـ `BlocBuilder` و `BlocProvider`.
- **الألوان والثيمات:**
  - يتم استبدال الألوان القديمة واستخدامها من امتداد النظام (System Theme Extension): `context.appColors.primary.shade500` و `context.appColors.appBackgroundColor`.
  - الخطوط تستخدم من النظام: `context.theme.textTheme.bodyMedium`.
- **تحديث المكونات المُزالة:** مثل حزمة `expandable` التي تم استبدالها بمكون ഫلاتر الأساسي `ExpansionTile` لعدم تواجدها في المشروع الحالي أو لتجنب أخطاء التجميع.
- **الأشرطة العلوية (AppBars):** يتم وضع شريط التطبيق `HomeAppBar()` أو شريط يتم تخصيصه داخل قائمة الودجات ليتناسب مع تخطيط الـ Scaffold الجديد.

---

## 3. ما نحتاجه لنقل أي ميزة جديدة (Required Files Checklist)
لكي يتم تنفيذ الميزة بشكل صحيح ومطابق بنسبة 100% للتصميم والبيانات، نحتاج دائماً من المشروع القديم إلى:
1. **أكواد الـ UI القديمة:** الشاشات الرئيسية والـ Widgets (مثل `ZadPage` و Components الخاصة بها).
2. **أكواد المتحكمات (Controllers):** مثل `ZadController` لمعرفة اللوجيك أو القوائم المطلوبة.
3. **أكواد النماذج (Models):** إذا كانت الميزة تستخدم Models مخصصة لعرض البيانات الوهمية.
4. **أية معطيات مفتاحية (Constants):** كمسارات الصور أو التسميات المختلفة. 

بمجرد الحصول على هذه الأكواد، نقوم بهيكلتها حسب الخطوات المذكورة ليتم تفعيل الـ Feature بنجاح! 🎊
