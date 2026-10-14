part of app_material;

class TextAligner extends Text{
  const TextAligner(super.data, {super.key,required super.style,super.maxLines,super.overflow});

  @override
  TextDirection? get textDirection => data?.getTextDirection;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: textDirection == TextDirection.ltr ? Alignment.centerLeft :Alignment.centerRight,
      child: super.build(context),
    );
  }
}
