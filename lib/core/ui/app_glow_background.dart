import 'package:flutter/material.dart';

class AppGlowBackground extends StatelessWidget {
  final Widget child;
  const AppGlowBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),

        PositionedDirectional(
          top: -18,
          end: -5,
          child: IgnorePointer(
            child: Container(
              clipBehavior: Clip.none,
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: AlignmentDirectional.topEnd,
                  radius: 1,
                  colors: [
                    Color(0x06FFE29A), // bright glow
                    Color(0x06FFC76A),
                    Color(0x00000000), // dark edge
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
