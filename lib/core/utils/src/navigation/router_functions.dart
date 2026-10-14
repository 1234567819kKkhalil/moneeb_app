part of app_utils;

class AppRouteNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<BuildContext> getAppContextWhenAvailable() async {
    BuildContext? appContext = navigatorKey.currentContext;

    if (appContext != null) {
      debugPrint("CONTEXT IS MOUNTED WITHOUT WAITING");
      return appContext;
    }

    Completer completer = Completer();

    Timer? timer = Timer.periodic(const Duration(seconds: 1), (_) {
      debugPrint("STARTED A PERIODIC TIMER TO GET CONTEXT");
      appContext = navigatorKey.currentContext;

      if (appContext != null) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    await completer.future;
    timer.cancel();
    timer = null;

    debugPrint("CONTEXT MOUNTED SUCCESSFULLY");

    return appContext!;
  }

  //Handle pages with ids
  static const String routeIdIdentifier = '?id=';
  static const String dialogRoutePrefix = '-Dialog-';
  static const String bottomSheetRoutePrefix = '-BottomSheet-';

  static String formatRouteWithId(String routeName, String? parentId) {
    if (parentId != null) {
      return "$routeName$routeIdIdentifier$parentId";
    }

    return routeName;
  }

  static String getAbsoluteRouteNameFrom(String routeName) {
    return routeName.split(AppRouteNavigator.routeIdIdentifier).firstOrNull ??
        routeName;
  }

  static void push<T extends Object?>(
    BuildContext context,
    String routeName,
    Widget widget, {
    Function(T? data)? onPoppedWithData,
  }) async {
    Navigator.of(context, rootNavigator: true)
        .pushNamed<T?>(routeName, arguments: RouteInfoModel(page: widget))
        .then((value) {
          if (onPoppedWithData != null) {
            onPoppedWithData(value);
          }
        });
  }

  static Future<dynamic> pushIfNotCurrent(
    BuildContext context,
    String routeName,
    Widget widget, {
    bool useAbsoluteName = true,
  }) async {
    if (!NavObserver.instance.isCurrentPage(
      routeName,
      includeId: !useAbsoluteName,
    )) {
      return await Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamed(routeName, arguments: RouteInfoModel(page: widget));
    }
  }

  static Future<T?> pushAnimatedOpacity<T>(
    BuildContext context,
    String routeName,
    Widget widget, {
    Duration? duration,
    bool fullscreenDialog = false,
    Color barrierBgColor = Colors.transparent,
    bool withDismissible = false,
  }) async {
    return await Navigator.of(context, rootNavigator: true).pushNamed(
      routeName,
      arguments: RouteInfoModel(
        page: widget,
        materialPageRoute: (page) {
          return FadeTransitionRoute<T>(
            isFullscreenDialog: fullscreenDialog,
            child: page,
            duration: duration,
            routeName: routeName,
            barrierBgColor: barrierBgColor,
          );
        },
      ),
    );
  }

  static Future<T?> pushTransparent<T>(
    BuildContext context,
    Widget widget, {
    bool rootNavigator = false,
    RouteSettings? settings,
    String? routeName,
    bool withDismissible = true,
  }) {
    return Navigator.of(context, rootNavigator: rootNavigator).push(
      PageRouteBuilder(
        fullscreenDialog: true,
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (BuildContext context, _, __) {
          return widget;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          ); // Fade transition
        },
        settings: settings ?? RouteSettings(name: routeName),
      ),
    );
  }

  static Future<dynamic> pushAnimatedSlide(
    BuildContext context,
    String routeName,
    Widget widget, {
    Offset? currentTapOffset,
  }) async {
    return await Navigator.of(context, rootNavigator: true).pushNamed(
      routeName,
      arguments: RouteInfoModel(
        page: widget,
        materialPageRoute: (page) {
          return SlideTransitionRoute(
            page,
            settings: RouteSettings(name: routeName),
            currentTapOffset: currentTapOffset,
          );
        },
      ),
    );
  }

  static Future<T?> pushWithDragToPopTransition<T>(
    BuildContext context,
    String routeName,
    Widget widget,
  ) async {
    return await Navigator.of(context, rootNavigator: true).pushNamed(
      routeName,
      arguments: RouteInfoModel(
        page: widget,
        materialPageRoute: (page) => DragToPopMaterialPageRoute(
          settings: RouteSettings(name: routeName),
          builder: (BuildContext context) {
            return page;
          },
        ),
      ),
    );
  }

  static Future<void> pushReplacement(
    BuildContext context,
    String routeName,
    Widget widget,
  ) async {
    //it will execute the enter animation
    await Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed(routeName, arguments: RouteInfoModel(page: widget));
  }

  static Future<void> pushAndRemoveUntil(
    BuildContext context,
    String routeName,
    Widget widget, {
    String? removeUntil,
    bool useResponsiveScaledBox = true,
    useAbsoluteName = true,
  }) async {
    await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      routeName,
      arguments: RouteInfoModel(page: widget),
      (route) {
        if (removeUntil == null) {
          return false;
        }

        if (useAbsoluteName) {
          return getAbsoluteRouteNameFrom(route.settings.name ?? '') ==
              getAbsoluteRouteNameFrom(removeUntil);
        }

        return route.settings.name == removeUntil;
      },
    );
  }

  static Future<T?> pushCustomRoute<T>(
    BuildContext context,
    ModalRoute<T> modalRoute,
  ) async {
    return await Navigator.of(context, rootNavigator: true).push(modalRoute);
  }

  static void pop<T>(BuildContext context, {T? data}) {
    final nav = Navigator.of(context, rootNavigator: true);

    if (nav.canPop()) {
      nav.pop(data);
    }
  }

  static void maybePop<T>(BuildContext context, {T? data}) {
    Navigator.of(context, rootNavigator: true).maybePop(data);
  }

  static void popUntil(
    BuildContext context, {
    String? removeUntil,
    bool rootNavigator = true,
    bool useAbsoluteName = true,
  }) {
    Navigator.of(context, rootNavigator: rootNavigator).popUntil((route) {
      if (removeUntil == null) {
        return route.isFirst;
      }

      if (useAbsoluteName) {
        return getAbsoluteRouteNameFrom(route.settings.name ?? '') ==
            getAbsoluteRouteNameFrom(removeUntil);
      }

      return route.settings.name == removeUntil;
    });
  }

  static void removeCurrentRoute(BuildContext context) {
    final route = ModalRoute.of(context);

    if (route != null) {
      Navigator.removeRoute(context, route);
    }
  }
}

class RouteInfoModel {
  final Widget page;
  final PageRoute Function(Widget child)? materialPageRoute;

  const RouteInfoModel({required this.page, this.materialPageRoute});
}
