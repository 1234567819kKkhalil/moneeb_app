[SSH Key]
Link
ssh-keygen -t rsa
pbcopy < ~/.ssh/id_rsa.pub

[Firebase]
dart pub global activate flutterfire_cli

[Launcher Icon]
dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
flutter pub run flutter_launcher_icons

[Native Splash]
flutter pub run flutter_native_splash:remove
flutter pub run flutter_native_splash:create

[Localization]
flutter gen-l10n

[Injectable]
dart run build_runner build

[Json Serializable]
dart run build_runner clean
dart run build_runner build –delete-confliction-outputs

[SHA1 - SHA256]
cd android ; keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
./gradlew app:signingReport

[Jks]
keytool -genkey -v -keystore [path of the jks] -keyalg RSA -keysize 2048 -validity 10000 -alias upload