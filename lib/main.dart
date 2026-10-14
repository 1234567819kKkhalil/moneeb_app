import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'builder_screen.dart';
import 'core/app_material/material.dart';
import 'core/base/di/data_injector.dart';
import 'core/base/fire_base/fire_base.dart';
import 'core/base/localization/localization.dart';
import 'core/config/config.dart';
import 'core/ui/app_glow_background.dart';
import 'core/utils/utils_imports.dart';
import 'features/authentication/authentication_imports.dart';
import 'initialize_app_configs.dart';
import 'l10n/app_localizations.dart';

void main() {
  // Silence every print()/debugPrint() call in the app (and its
  // dependencies) app-wide, without touching each call site.
  debugPrint = (String? message, {int? wrapWidth}) {};

  runZonedGuarded(
    () async {
      await initializeAppConfig();

      runApp(const MyApp());
    },
    (error, stack) => FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack)),
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {},
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //clear the app icon badge whenever the app is opened
    LocalNotificationService.instance.clearAllNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //clear the app icon badge whenever the app is reopened from background
      LocalNotificationService.instance.clearAllNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: false,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppThemeCubit()),
          BlocProvider(create: (context) => AppLanguageCubit()..init()),
          BlocProvider(create: (context) => AuthenticationBloc()),
        ],
        child: BlocConsumer<AppLanguageCubit, AppLanguageState>(
          listener: (context, state) {
            //reset the navigator key is essential so the MaterialApp could refresh
            //because without resetting the navigatorKey, material app will not reset and the pages will not get refreshed after lang changed
            AppRouteNavigator.navigatorKey = GlobalKey<NavigatorState>();

            //reset the NavObserver to delete old routes data from NavStack
            NavObserver.reset();
          },
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                // This line is triggering the didChangeDependencies for all items in the current page, so it is not necessary if the above line is working
                // FocusScope.of(context).requestFocus(FocusNode());
              },
              child: DevicePreview.appBuilder(
                context,
                BlocBuilder<AppThemeCubit, ThemeMode>(
                  builder: (context, themeState) {
                    return MaterialApp(
                      key: ValueKey(state.langCode),
                      debugShowCheckedModeBanner: false,
                      // ignore: deprecated_member_use
                      useInheritedMediaQuery: true,
                      navigatorObservers: [NavObserver.instance],
                      themeMode: ThemeMode
                          .dark, //todo: return to themeState wen we apply light theme
                      theme: AppThemes.light,
                      darkTheme: AppThemes.dark,
                      locale: Locale(state.langCode.name),
                      localizationsDelegates:
                          AppLocalizations.localizationsDelegates,
                      supportedLocales: AppLocalizations.supportedLocales,
                      title: Constants.appName,
                      navigatorKey: AppRouteNavigator.navigatorKey,
                      builder: (context, child) {
                        injector<LocalizationContainer>().setLocalizer(context);

                        return ResponsiveBreakpoints.builder(
                          breakpoints: [
                            const Breakpoint(start: 0, end: 450, name: MOBILE),
                            const Breakpoint(
                              start: 451,
                              end: 800,
                              name: TABLET,
                            ),
                            const Breakpoint(
                              start: 801,
                              end: 1920,
                              name: DESKTOP,
                            ),
                            const Breakpoint(
                              start: 1921,
                              end: double.infinity,
                              name: '4K',
                            ),
                          ],
                          child: MediaQueryScaleOverrider(
                            child: AppBlockerLoaderWidget(child: child!),
                          ),
                        );
                      },
                      initialRoute: BuilderScreen.routeName,
                      onGenerateRoute: (settings) {
                        RouteInfoModel? routeInfo =
                            settings.arguments as RouteInfoModel?;

                        PageRoute pageRoute;
                        Widget page;
                        String? routeName = settings.name;

                        //set main page
                        if (routeName == '/') {
                          page = const BuilderScreen();
                        } else {
                          assert(
                            routeInfo?.page != null,
                          ); //route info can not be null here
                          page = routeInfo!.page;
                        }

                        //set responsive scaled box on the page
                        page = AppResponsiveScaledBox(
                          calculateMediaQuery: false,
                          child: AppGlowBackground(child: page),
                        );

                        //set page route if passed
                        if (routeInfo?.materialPageRoute != null) {
                          pageRoute = routeInfo!.materialPageRoute!(page);
                        } else {
                          pageRoute = MaterialPageRoute(
                            settings: RouteSettings(name: routeName),
                            builder: (context) {
                              return page;
                            },
                          );
                        }
                        return pageRoute;
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
