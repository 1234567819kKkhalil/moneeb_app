part of app_material;

typedef ListenerWithValue = void Function(bool value);

class AppBlockerLoader {
  //variables
  static final ValueNotifier<BlockerLoaderInfoModel> _showLoadingNotifier = ValueNotifier(
      const BlockerLoaderInfoModel(isLoading: false)
  );

  static final List<(ListenerWithValue, VoidCallback)> _listeners = [];

  static void addListener(ListenerWithValue listener){
    void wrapper() {
      listener(_showLoadingNotifier.value.isLoading);
    }

    _listeners.add((listener, wrapper));

    _showLoadingNotifier.addListener(wrapper);
  }

  static void removeListener(ListenerWithValue listener){
    var item = _listeners.firstWhereOrNull((e) => e.$1 == listener);

    if(item != null){
      _showLoadingNotifier.removeListener(item.$2);
      _listeners.remove(item);
    }
  }

  static void showLoader(BuildContext context, {String? text}){
    _showLoadingNotifier.value = BlockerLoaderInfoModel(isLoading: true, text: text);
  }

  static void removeLoader() {
    _showLoadingNotifier.value = const BlockerLoaderInfoModel(isLoading: false);
  }
}

class AppBlockerLoaderWidget extends StatelessWidget {
  final Widget child;

  const AppBlockerLoaderWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppBlockerLoader._showLoadingNotifier,
      builder: (context, loadingInfo, children) {
        return IgnorePointer(
          ignoring: loadingInfo.isLoading,
          child: Stack(
            children: [
              children!,

              if (loadingInfo.isLoading)
                Positioned.fill(
                  child: AppResponsiveScaledBox(
                    child: PopScope(
                      canPop: false,
                      child: Scaffold(
                        backgroundColor: context.colorDecider(onLight: (appColors) => appColors.neutral.shade900.withValues(alpha:0.5), onDark: (appColors) => appColors.neutral.shade50.withValues(alpha:0.5),),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,

                            children: [
                              CustomAnimationLoading(),

                              if(loadingInfo.text != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: PaddingDimensions.large),
                                  child: Text(
                                    loadingInfo.text!,
                                    style: context.regular.copyWith(
                                      color: context.appColors.neutral.shade50,
                                      fontSize: Dimensions.xxLarge,
                                      height: -0.6,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        );
      },
      child: child,
    );
  }
}