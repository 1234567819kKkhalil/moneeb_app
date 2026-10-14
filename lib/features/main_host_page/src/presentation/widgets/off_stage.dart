part of main_host_page;

class OffStage extends StatelessWidget {
  final bool isActive;
  final Widget child;

  const OffStage({super.key, required this.isActive, required this.child});

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return child;
    }
    return const SizedBox.shrink();
  }
}


