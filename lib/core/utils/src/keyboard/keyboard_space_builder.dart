part of app_utils;

class KeyboardSpaceBuilder extends StatefulWidget {
  final bool withPadding;

  const KeyboardSpaceBuilder({
    super.key,
    this.withPadding = true,
  });

  @override
  State<KeyboardSpaceBuilder> createState() =>
      _KeyboardSpaceBuilderState();
}

class _KeyboardSpaceBuilderState
    extends State<KeyboardSpaceBuilder> with WidgetsBindingObserver {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 50),
      child: SizedBox(
        height: MediaQuery.of(context).viewInsets.bottom + (widget.withPadding ? 20 : 0),
      ),
    );
  }
}
