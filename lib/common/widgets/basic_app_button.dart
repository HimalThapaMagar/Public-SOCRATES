import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BasicAppButton extends StatelessWidget {
  VoidCallback onPressed;
  String text;
  final double? height;
  BasicAppButton(
      {required this.onPressed, required this.text, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: Size(double.infinity, height ?? 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );
  }
}
