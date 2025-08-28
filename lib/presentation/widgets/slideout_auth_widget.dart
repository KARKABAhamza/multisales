import 'package:flutter/material.dart';

class SlideoutAuthWidget extends StatelessWidget {
  final Widget child;
  final bool show;
  final VoidCallback? onClose;
  const SlideoutAuthWidget({
    super.key,
    required this.child,
    this.show = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      right: show ? 0 : -350,
      top: 0,
      bottom: 0,
      width: 350,
      child: Material(
        elevation: 16,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
