# 📱 Mobile Security Checklist

This document is a security checklist for developers to improve app safety.  
**It does not promote phishing or unauthorized access.**

---

## ⚠️ DISCLAIMER

This document is intended for **ethical use only**.  
It provides best practices for securing mobile applications and is meant for developers and security professionals.  
It does **not** promote hacking, phishing, or any illegal activity.

---

## ✅ Security Areas

### 🛡️ Input Validation

- Validate and sanitize input to prevent malformed input (e.g., SQL Injection, XSS).
- Prevent rapid/frequent interactions (e.g., throttle user inputs).

#### 🧪 Implementation Example: Input Sanitization

```dart
class SecureInputFormatter extends TextInputFormatter {
  static final RegExp _unsafeCharsRegex = RegExp('[<>"\'%;()&+/?~\\\\]');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final sanitized = newValue.text.replaceAll(_unsafeCharsRegex, '');

    int newOffset = newValue.selection.baseOffset;

    final beforeCursor = newValue.text.substring(0, newValue.selection.baseOffset);
    final removedBeforeCursor = beforeCursor.length - beforeCursor.replaceAll(_unsafeCharsRegex, '').length;
    newOffset = (newValue.selection.baseOffset - removedBeforeCursor).clamp(0, sanitized.length);

    return TextEditingValue(
      text: sanitized,
      selection: newValue.selection.copyWith(baseOffset: newOffset, extentOffset: newOffset),
    );
  }
}
```

Use the following if you want to **allow only specific characters**:

```dart
FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
```

---

### 🔑 Key Management

- Store keys securely using Dart Environment Variables (`--dart-define`) and ignore in `.gitignore`.
- Avoid hardcoding in source files.

#### ✅ Android: `build.gradle`

```groovy
def dartEnvironmentVariables = [:]

if (project.hasProperty('dart-defines')) {
  dartEnvironmentVariables = project.property('dart-defines')
      .split(',')
      .collectEntries { entry ->
          def decoded = new String(entry.decodeBase64(), 'UTF-8')
          def pair = decoded.split('=')
          if (pair.length == 2) {
              [(pair[0]): pair[1]]
          } else {
              [:]
          }
      }
}

buildConfigField 'String', 'intercomAppId', "\"${dartEnvironmentVariables.intercomAppId}\""
```

#### ✅ iOS: `AppDelegate.swift`

```swift
if let apiKey = Bundle.main.object(forInfoDictionaryKey: "INTERCOM_IOS_API_KEY") as? String,
   let appId = Bundle.main.object(forInfoDictionaryKey: "INTERCOM_APP_ID") as? String {
   Intercom.setApiKey(apiKey, forAppId: appId)
}
```

#### ✅ Android: `AndroidManifest.xml`

In `defaultConfig`:

```groovy
manifestPlaceholders += [
    googleMapsApiKey: dartEnvironmentVariables.googleMapsApiKey
]
```

In `AndroidManifest.xml`:

```xml
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="${googleMapsApiKey}" />
```

---

### 🔐 Data Encryption

- Do **not** log sensitive data.
- Use AES, Fernet, or Salsa for encryption.
- Use secure storage or encrypted shared preferences.
- Prevent screenshots on sensitive screens.

#### 🛡️ AES Encryption Example

```dart
abstract class Encryption {
  final String ENCRYPTION_KEY = Env.ENCRYPTION_KEY;
  final String ENCRYPTION_IV = Env.ENCRYPTION_IV;

  String? encrypt(String? plainText);
  String? decrypt(String? plainText);
}

class AESEncryption extends Encryption {
  @override
  String? encrypt(String? plainText) {
    try {
      final key = Key.fromBase64(ENCRYPTION_KEY);
      final iv = IV.fromBase64(ENCRYPTION_IV);

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      if (plainText != null && plainText.isNotEmpty) {
        return encrypter.encrypt(plainText.trim(), iv: iv).base64;
      }
    } catch (_) {}
    return plainText;
  }

  @override
  String? decrypt(String? plainText) {
    try {
      final key = Key.fromBase64(ENCRYPTION_KEY);
      final iv = IV.fromBase64(ENCRYPTION_IV);

      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      if (plainText != null && plainText.isNotEmpty) {
        return encrypter.decrypt(Encrypted.from64(plainText.trim()), iv: iv);
      }
    } catch (_) {}
    return plainText;
  }
}

extension StringEncryption on String {
  String get encrypt => injector.get<Encryption>().encrypt(this) ?? '';
  String get decrypt => injector.get<Encryption>().decrypt(this) ?? '';
}
```

---

### 🖼️ Prevent Screenshots
```dart
class ScreenSaverProtector {
  ScreenSaverProtector._();
  static final _instance = ScreenSaverProtector._();
  factory ScreenSaverProtector() => _instance;
  int _disableCount = 0;

  Future<void> disableScreenShot() async {
    _disableCount++;
    if (_disableCount == 1) {
      await injector.get<ScreenSaver>().disableScreenShot();
    }
  }

  Future<void> enableScreenShot() async {
    if (_disableCount > 0) {
      _disableCount--;
      if (_disableCount == 0) {
        await injector.get<ScreenSaver>().enableScreenShot();
      }
    }
  }
}

abstract class ScreenSaver {
  Future<void> enableScreenShot();
  Future<void> disableScreenShot();
}

class ScreenSaverImp extends ScreenSaver {
  @override
  Future<void> disableScreenShot() async {
    await ScreenProtector.preventScreenshotOn();
  }

  @override
  Future<void> enableScreenShot() async {
    await ScreenProtector.preventScreenshotOff();
  }
}
```

---

### 🔒 Obfuscation

Use obfuscation for release builds.

#### ✅ Android (ProGuard / R8)

```groovy
buildTypes {
  release {
    minifyEnabled true
    shrinkResources true
    proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
  }
}
```

🧠 Tip: Use AI tools to generate `proguard-rules.pro` based on your code.

---

### 🧩 App Integrity

- Use Firebase AppCheck: Add token in header `X-Firebase-AppCheck`
- Detect rooted/jailbroken devices.
- Detect if app is installed from untrusted sources.
- Detect ADB enabled.

#### 🔍 Root Detection (Flutter + Native)

```dart
class CheckRootedDevices {
  static Future<bool> isDeviceRootedOrJailBroken(String bundleId) async {
    try {
      final isJailBroken = Platform.isIOS ? await SafeDevice.isJailBroken : false;
      final isSafeDevice = Platform.isAndroid ? await SafeDevice.isSafeDevice : true;
      final isRealDevice = await SafeDevice.isRealDevice;

      final isJailBroken2 = await JailbreakRootDetection.instance.isJailBroken;
      final isRealDevice2 = await JailbreakRootDetection.instance.isRealDevice;
      final isTampered = Platform.isIOS ? await JailbreakRootDetection.instance.isTampered(bundleId) : false;

      return isJailBroken || !isSafeDevice || !isRealDevice || isJailBroken2 || !isRealDevice2 || isTampered;
    } on PlatformException catch (_) {
      return false;
    }
  }
}
```

#### 🧪 ADB Detection (Kotlin + Dart)

**Android (`MainActivity.kt`):**

```kotlin
val isEnabled = Settings.Global.getInt(
  contentResolver,
  Settings.Global.ADB_ENABLED, 0
) == 1
result.success(isEnabled)
```

**Flutter:**

```dart
static Future<bool> isAdbEnabled() async {
  try {
    return await _channel.invokeMethod('isAdbEnabled');
  } catch (_) {
    return false;
  }
}
```

---

### 🔐 Permissions Management

- Audit all requested permissions.
- Avoid unnecessary permissions.

---

### 🔐 Certificate Pinning

- Pin SSL certificates to protect from MITM attacks.

---

### 🧊 Throttling User Interactions

Prevent abuse or rapid user tapping.

```dart
class Throttler {
  final int milliseconds;
  Timer? _throttleTimer;

  Throttler({required this.milliseconds});

  void throttle({required Function() onThrottle}) {
    if (_throttleTimer == null) {
      _throttleTimer = Timer(Duration(milliseconds: milliseconds), () {
        _throttleTimer = null;
      });
      onThrottle();
    }
  }

  void cancel() {
    _throttleTimer?.cancel();
    _throttleTimer = null;
  }
}
```

**Usage:**

```dart
final Throttler throttler = Throttler(milliseconds: 1250);

onTap: () {
  throttler.throttle(
    onThrottle: () {
      widget.onPressed();
    },
  );
}
```

---

## ✅ Additional Suggestions

- Enable **2FA (Two-Factor Authentication)** for sensitive actions.
- Use **biometrics** or **device credentials** for extra layer of security.
- Log out users on inactivity or app tampering.
- Use **app-specific permissions** or **scoped storage** for file access.

---

> 🛠 Keep this checklist updated as new security vulnerabilities emerge.