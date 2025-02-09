import 'package:flutter/material.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  // Sample prayer times data
  final Map<String, String> prayerTimes = {
    'Fajr': '04:30 AM',
    'Dhuhr': '12:15 PM',
    'Asr': '03:45 PM',
    'Maghrib': '06:15 PM',
    'Isha': '07:45 PM',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Today\'s Prayer Times',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...prayerTimes.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  entry.value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
} 