part of media_utils;

class FittedGridView extends StatefulWidget {
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(int remaining) remainingItemsOverlay;
  final int itemCount;
  final TextDirection? textDirection;
  final int maxItemDisplay;

  const FittedGridView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.remainingItemsOverlay,
    this.textDirection = TextDirection.ltr,
    this.maxItemDisplay = 4,
  });

  @override
  State<FittedGridView> createState() => _FittedGridViewState();
}

class _FittedGridViewState extends State<FittedGridView> {
  late int length;
  late int remainingItemsCount;
  late int halfLength;

  @override
  void initState() {
    _setLengths();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FittedGridView oldWidget) {
    if (oldWidget != widget) {
      setState(() {
        _setLengths();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  _setLengths() {
    length = widget.itemCount;
    remainingItemsCount = length - widget.maxItemDisplay;

    if (remainingItemsCount > 0) {
      length = widget.maxItemDisplay;
    }

    halfLength = (length / 2).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, size) {
      if (length == 1) {
        return widget.itemBuilder(context, 0);
      }

      return Row(
        textDirection: widget.textDirection,
        children: [
          Expanded(
            child: Column(
              children: [
                for (int i = 0; i < halfLength; i++)
                  ...[
                    Expanded(
                      child: SizedBox(
                        width: _calculateWidth(i, size.maxWidth),
                        height: _calculateHeight(i, size.maxHeight),
                        child: widget.itemBuilder(context, i),
                      ),
                    ),

                    if(i < halfLength - 1)
                      const _BuildDivider()
                  ]

              ],
            ),
          ),

          if(length > 1)
            const _BuildDivider(horizontalDivider: true),

          Expanded(
            child: Column(children: [
              for (int i = halfLength; i < length; i++)
                ...[
                  if (remainingItemsCount > 0 && i == length - 1)
                    Expanded(
                      child: Stack(
                        children: [
                          SizedBox(
                            width: _calculateWidth(i, size.maxWidth),
                            height: _calculateHeight(i, size.maxHeight),
                            child: widget.itemBuilder(context, i),
                          ),
                          Positioned.fill(
                              child: widget
                                  .remainingItemsOverlay(remainingItemsCount)),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: SizedBox(
                        width: _calculateWidth(i, size.maxWidth),
                        height: _calculateHeight(i, size.maxHeight),
                        child: widget.itemBuilder(context, i),
                      ),
                    ),

                  if(i < length - 1)
                    const _BuildDivider()
                ]
            ]),
          )
        ],
      );
    });
  }

  _calculateWidth(int index, double maxWidth) {
    if ((length == 3 && index == 2) || length == 1) {
      return maxWidth;
    }

    return maxWidth / 2;
  }

  _calculateHeight(int index, double maxHeight) {
    if ((length == 3 && index == 2) || length < 3) {
      return maxHeight;
    }

    return maxHeight / 2;
  }
}

class _BuildDivider extends StatelessWidget {
  final bool horizontalDivider;
  const _BuildDivider({this.horizontalDivider = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: horizontalDivider ? 3 : 0,
      height: horizontalDivider ? 0 : 3,
      child: ColoredBox(
        color: context.appColors.neutral.shade300,
      ),
    );
  }
}
