part of custom_pagination;

class ListViewController extends FlutterListViewController {
  final Duration _defaultDuration = const Duration(milliseconds: 200);

  final ValueNotifier<bool> jumpArrowVisibilityNotifier =
  ValueNotifier<bool>(true);
  final ValueNotifier<int?> unReadMessagesCountNotifier =
  ValueNotifier<int?>(null);

  ListViewController() {
    addListener(_scrollListener);
  }

  /// [isLastIndexVisible] Is last index visible or not
  bool get isLastIndexVisible {
    if (hasClients) {
      return (!(position.pixels + 200 < position.maxScrollExtent));
    }
    return true;
  }

  void _scrollListener() {
    jumpArrowVisibilityNotifier.value = isLastIndexVisible;

    if (jumpArrowVisibilityNotifier.value == true) {
      unReadMessagesCountNotifier.value = 0;
    }
  }

  @override
  void dispose() {
    removeListener(_scrollListener);
    jumpArrowVisibilityNotifier.dispose();
    unReadMessagesCountNotifier.dispose();
    super.dispose();
  }

  void enhancedAnimateTo({required int targetIndex, int? currentIndex}) {
    if (!hasClients) return;

    void animateLogic() {
      bool isTooFarToAnimate =
      currentIndex == null ? true : (targetIndex - currentIndex).abs() > 20;

      if (isTooFarToAnimate) {
        sliverController.jumpToIndex(
          targetIndex,
          offset: 100,
          offsetBasedOnBottom: true,
        );
      } else {
        sliverController.animateToIndex(
          targetIndex,
          duration: const Duration(milliseconds: 250),
          curve: Curves.linear,
        );
      }

      //because scroll listener does not get triggered while using jump or animate in this FlutterListController
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollListener());
    }

    if (position.isScrollingNotifier.value == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        animateLogic();
      });
    } else {
      animateLogic();
    }
  }

  void scrollToEndChat(BuildContext context,int itemsLength) {
    if (!hasClients) return;

    unReadMessagesCountNotifier.value = 0;
    if(position.pixels >= (position.maxScrollExtent - 250) || position.isScrollingNotifier.value == true) {
      //because jumpToIndex and animateToIndex does not get triggered while scrolling
      //and this is has issue too while scrolling, it scroll to the half of the last item, but at least it scrolls, so we made this logic
      animateTo(position.maxScrollExtent,
        duration: _defaultDuration,
        curve: Curves.ease,
      ).then((_) =>  _scrollListener());
    } else {
      if(offset < (position.maxScrollExtent - context.height * 3)){
        sliverController.jumpToIndex(itemsLength);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollListener();//we must do this because this package does not get its listener to be triggered when using jumpToIndex or animateToIndex
        },);
      } else {
        sliverController
            .animateToIndex(
          itemsLength,
          duration: const Duration(milliseconds: 280),
          curve: Curves.linear,
        )
            .then((value) => _scrollListener());
      }
    }
  }

  void animateToShowTyping({required BuildContext context, bool isNewMessage = false, bool hasAttachment = false}) {
    if (!hasClients) return;

    final approximateExtentAfter = (hasAttachment ? 500 : 300);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (position.extentAfter < approximateExtentAfter || !(position.pixels + approximateExtentAfter < position.maxScrollExtent)) {
        animateTo(position.maxScrollExtent, duration: _defaultDuration, curve: Curves.easeOut)
            .then((_) {
          unReadMessagesCountNotifier.value = 0;
          jumpArrowVisibilityNotifier.value = true;
        });
      } else {
        if (isNewMessage == true) {
          unReadMessagesCountNotifier.value = (unReadMessagesCountNotifier.value ?? 0) + 1;
        }
      }
    });
  }


  Future<void> animateToIndex({
    required int index,
    int milliseconds = 250,
    Curve curve = Curves.linear,
  }) async {
    if (hasClients) {
      sliverController.animateToIndex(
        index,
        duration: Duration(milliseconds: milliseconds),
        curve: curve,
      );
    }
  }

  void jumpToIndex(
      {required int index,
        double offset = 100,
        bool offsetBasedOnBottom = false}) {
    if (hasClients) {
      sliverController.jumpToIndex(
        index,
        offset: 100,
        offsetBasedOnBottom: offsetBasedOnBottom,
      );
    }
  }
}
