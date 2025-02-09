import 'package:flutter/material.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double qiblaDirection = 0.0; // This would be replaced with actual Qibla direction

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Direction'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Face this direction to pray:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Transform.rotate(
              angle: qiblaDirection,
              child: const Icon(
                Icons.explore,
                size: 150,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '${qiblaDirection.toStringAsFixed(1)}° from North',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 