part of app_material;

class MediaQueryScaleOverrider extends StatelessWidget {
  final Widget child;
  const MediaQueryScaleOverrider({super.key, required this.child,});

  @override
  Widget build(BuildContext context) {
    final width = ResponsiveScaleHelper.getScaledWidth(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        MediaQueryData mediaQueryData = MediaQuery.of(context);

        double aspectRatio = constraints.maxWidth / constraints.maxHeight;
        double scaledWidth = width;
        double scaledHeight = width / aspectRatio;

        EdgeInsets scaledViewInsets = ResponsiveScaleHelper.getScaledViewInsets(
            mediaQueryData: mediaQueryData,
            screenSize: mediaQueryData.size,
            scaledSize: Size(scaledWidth, scaledHeight));
        EdgeInsets scaledViewPadding = ResponsiveScaleHelper.getScaledViewPadding(
            mediaQueryData: mediaQueryData,
            screenSize: mediaQueryData.size,
            scaledSize: Size(scaledWidth, scaledHeight));
        EdgeInsets scaledPadding = ResponsiveScaleHelper.getScaledPadding(
            padding: scaledViewPadding, insets: scaledViewInsets);

        return MediaQuery(
          data: mediaQueryData.copyWith(
            size: Size(scaledWidth, scaledHeight),
            viewInsets: scaledViewInsets,
            viewPadding: scaledViewPadding,
            padding: scaledPadding,
            // Ignore the device setting and follow the app's own clock format,
            // so TimeOfDay.format(context) / showTimePicker / material time
            // widgets match the rest of the app. See [AppTimeFormat].
            alwaysUse24HourFormat: AppTimeFormat.use24Hour,
          ),
          child: child,
        );
      },
    );
  }


}
