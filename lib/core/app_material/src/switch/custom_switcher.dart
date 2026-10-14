part of app_material;

class CustomSwitcher extends StatelessWidget {
  final Widget rightChild;
  final Widget leftChild;
  final double childWidth;
  final bool value;
  final void Function(bool value) onChange;
  final bool applySwitchOffColor;

  const CustomSwitcher({
    required this.rightChild,
    required this.leftChild,
    required this.value,
    required this.onChange,
    super.key,
    this.childWidth = 35,
    this.applySwitchOffColor = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isApplySwitchOffColor = applySwitchOffColor && value == false;
    Color switchBgColor =
        isApplySwitchOffColor ? context.appColors.neutral.shade50 : context.appColors.primary.shade500;
    return GestureDetector(
      onTap: () {
        onChange(!value);
      },
      onHorizontalDragStart: (details) {
        onChange(!value);
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: AnimatedContainer(
          // height: 40,
          duration: const Duration(milliseconds: 100),
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: switchBgColor,
          ),
          // padding: EdgeInsets.all(PaddingDimensions.small),
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                padding: const EdgeInsets.all(4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: childWidth,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(
                        PaddingDimensions.normal,
                      ),
                      child: leftChild,
                    ),
                    Container(
                      width: childWidth,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(
                        PaddingDimensions.normal,
                      ),
                      child: rightChild,
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(
                  value ? (childWidth + PaddingDimensions.small) : 5.0,
                  0.0,
                  0.0,
                ),
                child: Container(
                  width: childWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color:  context.appColors.neutral.shade50,
                  ),
                  alignment: AlignmentDirectional.center,
                  padding: const EdgeInsets.all(
                    PaddingDimensions.normal,
                  ),
                  child: value ? rightChild : leftChild,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
