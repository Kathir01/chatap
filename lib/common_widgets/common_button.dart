import 'package:flutter/material.dart';

class CommonButton extends StatefulWidget {
  const CommonButton({super.key, required this.icons});

  final IconData icons;

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          widget.icons,
          color: Colors.blueAccent,
        ),
        onPressed: () {});
  }
}
