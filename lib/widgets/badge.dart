import 'package:flutter/material.dart';

class MyBadge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;
  const MyBadge(
      {super.key,
      required this.child,
      required this.value,
      this.color = Colors.deepOrange});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
              constraints: BoxConstraints(minHeight: 16, minWidth: 16),
              child: Text(
                value,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            )),
      ],
    );
  }
}
