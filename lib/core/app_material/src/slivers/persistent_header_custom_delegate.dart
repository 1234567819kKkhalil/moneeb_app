part of app_material;

class PersistentHeaderCustomDelegate extends SliverPersistentHeaderDelegate {
  final Widget widget;

  double height = 0;
  PersistentHeaderCustomDelegate({required this.widget, this.height = 0});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      width: double.infinity,
      height: Dimensions.toolbarHeight + height,
      child: Center(child: widget),
    );
  }

  @override
  double get maxExtent => 56.0 + height;

  @override
  double get minExtent => 56.0 + height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
