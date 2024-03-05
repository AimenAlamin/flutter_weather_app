import 'package:flutter/material.dart';

class CardForecast extends StatelessWidget {
  const CardForecast(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});
  final String time;
  final IconData icon;
  final String temperature;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 34,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              temperature,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
