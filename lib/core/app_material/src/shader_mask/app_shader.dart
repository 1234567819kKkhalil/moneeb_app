part of app_material;

class AppShader extends StatelessWidget {
  final List<Color>? colors;
  final Widget child;

  const AppShader({super.key, this.colors, required this.child});

  @override
  Widget build(BuildContext context) {
    if(colors == null){
      return child;
    }
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors ?? [],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
