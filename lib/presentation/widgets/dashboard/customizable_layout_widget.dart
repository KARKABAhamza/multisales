import 'package:flutter/material.dart';

class CustomizableLayoutWidget extends StatefulWidget {
  final List<Widget> children;
  const CustomizableLayoutWidget({super.key, required this.children});

  @override
  State<CustomizableLayoutWidget> createState() =>
      _CustomizableLayoutWidgetState();
}

class _CustomizableLayoutWidgetState extends State<CustomizableLayoutWidget> {
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = List.from(widget.children);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex--;
          final item = _children.removeAt(oldIndex);
          _children.insert(newIndex, item);
        });
      },
      children: [
        for (int i = 0; i < _children.length; i++)
          Container(
            key: ValueKey(i),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: _children[i],
          ),
      ],
    );
  }
}
