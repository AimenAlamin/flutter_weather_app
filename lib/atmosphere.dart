import 'package:flutter/material.dart';

class Atmosphere extends StatelessWidget {
  const Atmosphere(
      {super.key,
      required this.atmoIcon,
      required this.atmoText,
      required this.atmoNumber});
  final IconData atmoIcon;
  final String atmoText;
  final String atmoNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          atmoIcon,
          size: 40,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          atmoText,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          atmoNumber,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
