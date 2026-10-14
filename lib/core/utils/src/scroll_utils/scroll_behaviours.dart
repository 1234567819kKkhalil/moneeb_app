part of app_utils;

/// [ClampingScrollBehavior] Handle Scroll Behavior
///    return RefreshIndicator(
///       color: AppColors.primary_300,
///       onRefresh: () async {
///         onRefresh();
///       },
///       child: ScrollConfiguration(
///        behavior: ClampingScrollBehavior(),
///         child: SingleChildScrollView(
///           physics: const AlwaysScrollableScrollPhysics(),
///       ),
///    );
class ClampingScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    // eliminate any behavior in Scrolling just return the child only.
    return child;
  }
}


class DisableOverscrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    // eliminate any behavior in Scrolling just return the child only.
    return child;
  }
}



