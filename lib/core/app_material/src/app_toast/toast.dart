part of app_material;

const Duration _reverseToastDuration = Duration(milliseconds: 440);
const Duration _showToastDuration = Duration(milliseconds: 620);

enum _ToastType { error, success, hint }

class AppToasts {
  static OverlayEntry? _overlayEntry;

  static void error(
    BuildContext context, {
    required String message,
    Duration? duration,
    Widget? suffixWidget,
  }) {
    if (!context.mounted) return;

    _overlayEntry?.remove();

    if (message.isEmpty) {
      message = appLocalizer.unexpectedError;
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _Toast(
        title: message,
        onDismiss: () {
          dismissToast();
        },
        duration: duration,
        suffixWidget: suffixWidget,
        toastType: _ToastType.error,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void success(
    BuildContext context, {
    required String message,
    Duration? duration,
    Widget? suffixWidget,
    double yAlignment = -0.8,
  }) {
    if (!context.mounted) return;

    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _Toast(
        title: message,
        onDismiss: () {
          dismissToast();
        },
        duration: duration,

        prefixWidget: /* suffixWidget ?? */ SvgPicture.asset(
          AssetPaths.iconCheck,
        ),

        toastType: _ToastType.success,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hint(
    BuildContext context, {
    required String message,
    Duration? duration,
    Widget? suffixWidget,
    double yAlignment = 0.8,
  }) {
    if (!context.mounted) return;

    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _Toast(
        title: message,
        onDismiss: () {
          dismissToast();
        },
        duration: duration,
        suffixWidget: suffixWidget,
        toastType: _ToastType.hint,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void dismissToast() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _Toast extends StatefulWidget {
  final VoidCallback onDismiss;
  final String title;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final Duration? duration;
  final _ToastType toastType;

  const _Toast({
    required this.onDismiss,
    required this.title,
    required this.toastType,

    this.suffixWidget,
    this.prefixWidget,
    this.duration,
  });

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late CurvedAnimation _sizeAnimation;
  late Duration dismissDuration;
  late List<Color> toastGradientColor;
  late Color textColor;
  late Color backgroundColor;

  @override
  void didChangeDependencies() {
    if (_animationController == null) {
      dismissDuration = widget.duration ?? _calculateDuration(widget.title);

      //set colors
      _setColors();

      _animationController = AnimationController(
        vsync: this,
        duration: _showToastDuration,
        reverseDuration: _reverseToastDuration,
      );

      _sizeAnimation = CurvedAnimation(
        parent: _animationController!,
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.fastEaseInToSlowEaseOut,
      );

      _animationController!.forward();
      _dismissToastAfterDuration();
    } else {
      _setColors();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _sizeAnimation.dispose();
    super.dispose();
  }

  void _setColors() {
    switch (widget.toastType) {
      case _ToastType.error:
        backgroundColor = context.appColors.danger.shade500;
        toastGradientColor = [
          context.appColors.danger.shade600,
          context.appColors.danger.shade600,
        ];
        textColor = context.appColors.neutral.shade900;
        break;
      case _ToastType.success:
        backgroundColor = context.appColors.primary.shade400;
        toastGradientColor = [
          context.appColors.primary.shade500,
          context.appColors.primary.shade200,
        ];
        textColor = context.colorDecider(
          onLight: (appColors) => appColors.neutral.shade900,
          onDark: (appColors) => appColors.neutral.shade900,
        );
        break;
      case _ToastType.hint:
        backgroundColor = context.appColors.secondary.shade300;
        toastGradientColor = [
          context.appColors.neutral.shade300,
          context.appColors.neutral.shade300,
        ];
        textColor = context.appColors.neutral.shade900;
        break;
    }
  }

  Duration _calculateDuration(String text) {
    // the average reading speed in letters per second
    int averageReadingSpeed = 14;

    // Calculate the number of letters in the text
    final letterCount = text.replaceAll(' ', '').length;

    // Estimate the reading time in milliseconds
    int readingTimeInSeconds = (letterCount / averageReadingSpeed).ceil();

    //set min duration to 2 seconds
    if (readingTimeInSeconds < 2) {
      readingTimeInSeconds = 2;
    }

    return Duration(seconds: readingTimeInSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsiveScaledBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingDimensions.pageHorizontalPadding,
          vertical: PaddingDimensions.medium,
        ),
        child: Align(
          alignment: const Alignment(0, -0.7),
          child: Material(
            elevation: 0,
            color: Colors.transparent,
            child: GestureDetector(
              onVerticalDragEnd: (_) {
                _onDismiss();
              },
              onHorizontalDragEnd: (_) {
                _onDismiss();
              },
              child: AnimatedBuilder(
                animation: _sizeAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _sizeAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(PaddingDimensions.medium),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    // gradient: LinearGradient(colors: toastGradientColor),
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: AnimatedBuilder(
                    animation: _sizeAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _sizeAnimation.value,

                        child: child!,
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.prefixWidget != null) ...[
                          widget.prefixWidget!,
                          const SizedBox(width: PaddingDimensions.xSmall),
                        ],
                        if (widget.toastType == _ToastType.error)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              end: PaddingDimensions.xSmall,
                            ),
                            child: Icon(
                              Icons.info,
                              color: context.appColors.neutral.shade900,
                              size: IconDimensions.normal,
                            ),
                          ),

                        Flexible(
                          child: Text(
                            widget.title,
                            style: context.medium.copyWith(color: textColor),
                            maxLines: 6,
                            overflow: TextOverflow.clip,
                            //textAlign: widget.title.getTextDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                          ),
                        ),
                        if (widget.suffixWidget != null) ...[
                          const SizedBox(width: PaddingDimensions.xSmall),
                          widget.suffixWidget!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _dismissToastAfterDuration() {
    Timer(dismissDuration, () {
      // use mounted here to prevent do dismiss animation if controller disposed
      if (mounted) {
        _onDismiss();
      }
    });
  }

  void _onDismiss() {
    _animationController?.reverse().then((value) {
      widget.onDismiss();
    });
  }
}
