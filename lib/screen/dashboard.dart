import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masjidfinder/constants.dart';
import 'package:masjidfinder/database/user_db/user_controller.dart';
import 'package:masjidfinder/screen/map_screen.dart';
import 'package:masjidfinder/screen/prayer_times_screen.dart';
import 'package:masjidfinder/screen/qibla_screen.dart';
import 'package:masjidfinder/screen/quran_screen.dart';
import 'package:masjidfinder/services/location_service.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'DashBoardScreenRoute')
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final String currentDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
   String userName = "loading";
  String userLocation = "Loading location...";

  final List<String> morningQuotes = [
    "The best of you are those who learn the Quran and teach it.",
    "Allah does not burden a soul beyond that it can bear.",
    "Verily, with hardship comes ease.",
    "The most beloved deed to Allah is the most regular and constant even if it were little.",
    "When you ask, ask Allah, and when you seek help, seek help from Allah."
  ];

  // Update navigation methods to use Navigator
  void _navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MosqueMapScreen()),
    );
  }

  void _navigateToPrayerTimes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrayerTimesScreen()),
    );
  }

  void _navigateToQibla() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QiblaScreen()),
    );
  }

  void _navigateToQuran() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuranScreen()),
    );
  }
    Future<void> _getUserLocation() async {
    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      final locationName = await locationService.getLocationName(
        position.latitude,
        position.longitude,
      );
      setState(() {
        userLocation = locationName;
      });
    } catch (e) {
      setState(() {
        userLocation = "Unable to get location";
      });
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserLocation();
  }
  @override
  Widget build(BuildContext context) {
    final user=context.read<UserController>().currentUser;

      userName=user!.email.toString();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Assalamu Alaikum",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      currentDate,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: primaryColor,
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Location",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  userLocation,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Morning Quote Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Morning Inspiration",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      morningQuotes[DateTime.now().day % morningQuotes.length],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Actions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.5,
                    children: [
                      _buildActionCard(
                        icon: Icons.mosque,
                        title: "Find Mosque",
                        color: Colors.blue,
                        onTap: _navigateToMap,
                      ),
                      _buildActionCard(
                        icon: Icons.access_time,
                        title: "Prayer Times",
                        color: Colors.green,
                        onTap: _navigateToPrayerTimes,
                      ),
                      _buildActionCard(
                        icon: Icons.explore,
                        title: "Qibla Direction",
                        color: Colors.orange,
                        onTap: _navigateToQibla,
                      ),
                      _buildActionCard(
                        icon: Icons.book,
                        title: "Quran Reading",
                        color: Colors.purple,
                        onTap: _navigateToQuran,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Nearby Mosques Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nearby Mosques",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Map View Coming Soon",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}