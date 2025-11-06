// Interactive widgets stubs for demo
import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final LoadingStyle style;
  final double size;
  const CustomLoadingIndicator({super.key, required this.style, required this.size});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(),
    );
  }
}

enum LoadingStyle { pulse, spinner }

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool showRipple;
  final Widget child;
  const CustomFloatingButton({super.key, required this.onPressed, required this.showRipple, required this.child});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

class AnimatedGradientBackground extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  const AnimatedGradientBackground({super.key, required this.colors, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
      ),
      child: child,
    );
  }
}
