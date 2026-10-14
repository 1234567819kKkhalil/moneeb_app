part of nested_paginated_list;

class DefaultRefreshInductorBuilder extends StatefulWidget {
  const DefaultRefreshInductorBuilder({
    super.key,
    this.onTap,
    required this.text,
    this.endOffset,
  });

  final Function()? onTap;
  final String text;
  final double? endOffset;

  @override
  State<DefaultRefreshInductorBuilder> createState() =>
      _DefaultRefreshInductorBuilderState();
}

class _DefaultRefreshInductorBuilderState
    extends State<DefaultRefreshInductorBuilder>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _slideController;

  late final Animation<Offset> _slideOffsetAnimation =
      Tween<Offset>(
        begin: const Offset(0.0, 3),
        end: Offset(0.0, widget.endOffset ?? -2),
      ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.elasticInOut),
      );

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _slideController.forward().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      // transformHitTests: true,
      position: _slideOffsetAnimation,
      child: GestureDetector(
        onTap: () async {
          if (widget.onTap != null) {
            if (!_animationController.isAnimating) {
              _animationController.repeat();
              await Future.delayed(const Duration(milliseconds: 500));
              _slideController.reverse().then((value) {
                widget.onTap!();
              });
            }
          }
        },
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: UnconstrainedBox(
            alignment: Alignment.topCenter,
            constrainedAxis: Axis.vertical,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: PaddingDimensions.normal,
                horizontal: PaddingDimensions.large,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: context.appColors.primary.shade500,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: Tween(
                      begin: 1.0,
                      end: 0.0,
                    ).animate(_animationController),
                    child: const AppSvg(
                      iconName: Icons.close,
                      color: Colors.white,
                      height: IconDimensions.xxSmall,
                      width: IconDimensions.xxSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: PaddingDimensions.normal,
                    ),
                    child: Text(
                      widget.text,
                      style: context.bold.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.small,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}

class AnimatedLoadingButton extends StatefulWidget {
  const AnimatedLoadingButton({
    super.key,
    this.text,
    this.isLoading = false,
    this.onTap,
  });
  final String? text;
  final bool isLoading;
  final void Function(AnimationController animation)? onTap;

  @override
  State<AnimatedLoadingButton> createState() => _AnimatedLoadingButtonState();
}

class _AnimatedLoadingButtonState extends State<AnimatedLoadingButton>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animate(widget.isLoading);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnimatedLoadingButton oldWidget) {
    if (oldWidget.isLoading != widget.isLoading) {
      _animate(widget.isLoading);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _animate(bool forward) {
    if (forward) {
      _animationController.repeat();
    } else {
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: GestureDetector(
        onTap: () async {
          if (!_animationController.isAnimating) {
            _animationController.repeat();
            if (widget.onTap != null) {
              widget.onTap!(_animationController);
            }
          }
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(
            vertical: PaddingDimensions.normal,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: PaddingDimensions.medium,
            horizontal: PaddingDimensions.medium,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: context.appColors.neutral.shade900,
          ),
          child: Row(
            children: [
              RotationTransition(
                turns: Tween(
                  begin: 1.0,
                  end: 0.0,
                ).animate(_animationController),
                child: const AppSvg(
                  iconName:
                      Icons.close, //Todo:- change close icons to refresh icons
                  color: Colors.white,
                  height: IconDimensions.xSmall,
                  width: IconDimensions.xSmall,
                ),
              ),
              // if(widget.text != null)
              AnimatedSize(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 400),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: widget.text != null ? 1 : 0,
                  child: SizedBox(
                    width: widget.text != null ? null : 0,
                    height: widget.text != null ? null : 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: PaddingDimensions.normal,
                      ),
                      child: Text(
                        widget.text ?? '',
                        style: context.bold.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
