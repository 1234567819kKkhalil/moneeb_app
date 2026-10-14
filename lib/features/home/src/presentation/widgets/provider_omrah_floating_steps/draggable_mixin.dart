import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';

const double _leftMarginPadding = 4;

mixin DraggableOverlayMixin<T extends StatefulWidget> on State<T>{
  //Overlay position
  double left = _leftMarginPadding;
  double top = 0;
  ScaleUpdateDetails? lastPositionDetailsValue;

  // This height and width will be manipulated
  double height = 0;
  double width = 0;

  // The default Maximized width and height
  double get defaultHeight;
  double get defaultWidth;
  //
  // bool isMinimized = false;
  // double minimizeWidth = 0;
  // double minimizeHeight = 0;

  //Dy and Dx boundaries to not go out of the screen
  double get maxAllowedDy => (adaptiveDeviceHeight - height - MediaQuery.viewPaddingOf(context).vertical - _leftMarginPadding).clamp(_leftMarginPadding, double.infinity);
  double get maxAllowedDx => (adaptiveDeviceWidth - width - _leftMarginPadding - MediaQuery.viewPaddingOf(context).horizontal).clamp(_leftMarginPadding, double.infinity);

  //Actual device height and width before responsive scale, and it is adaptive to work in both portrait and landscape
  double get adaptiveDeviceHeight => context.isLandscape
      ? DeviceSpecsUtils.instance.screenWidth ?? 50
      : DeviceSpecsUtils.instance.screenHeight ?? 50;

  double get adaptiveDeviceWidth => context.isLandscape
      ? DeviceSpecsUtils.instance.screenHeight ?? 50
      : DeviceSpecsUtils.instance.screenWidth ?? 50;

  Orientation? _initialReportedOrientation;
  bool isInitialized = false;

  @override
  void initState() {
    NavObserver.instance.addListener(_navObserverListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Set initial orientation value
    _initialReportedOrientation ??= MediaQuery.orientationOf(context);

    if(!isInitialized){
      // //Initialize start point values
      // if(defaultHeight == 0){
      //   defaultHeight = context.adaptiveHeight;
      // }
      //
      // if(defaultWidth == 0){
      //   defaultWidth = context.adaptiveWidth;
      // }

      // if(minimizeWidth == 0){
      //   minimizeWidth = width / 3;
      // }
      //
      // if(minimizeHeight == 0){
      //   minimizeHeight = height / 3;
      // }

      height = defaultHeight;
      width = defaultWidth;
    } else {
      // final newOrientation = MediaQuery.orientationOf(context);
      //
      // if(_initialReportedOrientation != newOrientation){
      //   height = context.adaptiveHeight;
      //   width = context.adaptiveWidth;
      // }
    }

    //Set overlay position
    if (lastPositionDetailsValue == null) {
      top = maxAllowedDy * 0.8;
      left = maxAllowedDx;
      lastPositionDetailsValue = ScaleUpdateDetails(focalPoint: Offset(left, top));
    } else {
      _fixPosition(lastPositionDetailsValue!);
    }

    isInitialized = true;
  }

  @override
  void dispose() {
    NavObserver.instance.removeListener(_navObserverListener);
    super.dispose();
  }

  //Detect bottom sheet and dialogs to minimize the video if any of them is opened
  bool isBottomSheetOrDialogDetected = false;

  void _navObserverListener() {
    final String currentRouteName = NavObserver.instance.currentPage ?? '';

    //Minimize the video if any bottom sheet or dialog is opened
    if (currentRouteName.startsWith(AppRouteNavigator.bottomSheetRoutePrefix) ||
        currentRouteName.startsWith(AppRouteNavigator.dialogRoutePrefix)) {
      //if (!isMinimized) {
      isBottomSheetOrDialogDetected = true;
      // onMinimizeChanged(true);
      // }
    } else {
      if (isBottomSheetOrDialogDetected) {
        isBottomSheetOrDialogDetected = false;
        //   if (isMinimized) {
        //  onMinimizeChanged(false);
        //   }
      }
    }
  }

  // void onMinimizeChanged(bool minimized) {
  //   setState(() {
  //     isMinimized = minimized;
  //
  //     if (isMinimized) {
  //       //Scale down the width and height of the overlay
  //       width = minimizeWidth;
  //       height = minimizeHeight;
  //     } else {
  //       //Scale up the width and height of the overlay
  //       width = defaultWidth;
  //       height = defaultHeight;
  //     }
  //   });
  //
  //   //Fix the position if it is not correct (it may happen when the device orientation is changed)
  //   if (lastPositionDetailsValue != null) {
  //     _fixPosition(lastPositionDetailsValue!);
  //   }
  // }

  void _fixPosition(ScaleUpdateDetails details) {
    //Set the position of the overlay to Left or Right
    if (details.focalPoint.dx <= adaptiveDeviceWidth / 2) {
      left = 4;
    } else {
      left = maxAllowedDx;
    }

    top = top.clamp(4, maxAllowedDy);

    setState(() {});
  }

  void _applyPositioning(ScaleUpdateDetails details){
    top = (top + details.focalPointDelta.dy).clamp(_leftMarginPadding, maxAllowedDy);
    left = (left + details.focalPointDelta.dx).clamp(_leftMarginPadding, maxAllowedDx);
    lastPositionDetailsValue = details;
  }

  void onRemoveOverlay();

  Widget get children;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthState>(
      listener: (context, state) {
        if (state.routingState.route != AuthRouteEnum.authenticated) {
          onRemoveOverlay();
        }
      },
      child: AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
        width: width,
        left: left + MediaQuery.viewPaddingOf(context).left,
        top: top + MediaQuery.viewPaddingOf(context).top,

        // left: isMinimized ? null : left + MediaQuery.viewPaddingOf(context).left,
        // top: isMinimized ? null : top + MediaQuery.viewPaddingOf(context).top,

        child: GestureDetector(
          onScaleUpdate: (details) {
            // Adjust position to ensure it stays within bounds
            _applyPositioning(details);

            setState(() {});
          },
          onScaleEnd: (details) {
            if(lastPositionDetailsValue != null){
              _fixPosition(lastPositionDetailsValue!);
            }
          },
          child: children,
        ),
      ),
    );
  }
}