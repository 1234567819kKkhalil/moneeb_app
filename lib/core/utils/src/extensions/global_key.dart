part of app_utils;

extension GlobalKeyExtensions on GlobalKey{
  Offset getOffset(){
    final RenderBox? targetBox = currentContext?.findRenderObject() as RenderBox?;
    return targetBox?.localToGlobal(Offset.zero) ?? const Offset(0, 0);
  }

  Size getSize(){
    final RenderBox? targetBox = currentContext?.findRenderObject() as RenderBox?;
    return targetBox?.size ?? const Size(0, 0);
  }
}