import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:masjidfinder/routes/app_router.dart';

import '../../components/dot_indicators.dart';
import '../../constants.dart';
import 'components/onbording_content.dart';

@RoutePage(name: 'OnboardingScreenRoute')
class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  final List<Onbord> _onbordData = [
    Onbord(
      icon: Icons.mosque,
      title: "Welcome to MasjidFinder",
      description: "Your guide to finding mosques near you with ease.",
    ),
    Onbord(
      icon: Icons.location_on,
      title: "Discover Nearby Mosques",
      description: "Locate mosques in your area with our advanced search.",
    ),
    Onbord(
      icon: Icons.access_time,
      title: "Prayer Times & Qibla",
      description: "Get accurate prayer times and Qibla direction.",
    ),
    Onbord(
      icon: Icons.people,
      title: "Community Connection",
      description: "Stay connected with your local Muslim community.",
    ),
    Onbord(
      icon: Icons.directions_walk,
      title: "Start Your Journey",
      description: "Begin exploring mosques and Islamic centers today.",
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    AutoRouter.of(context).push(LoginScreenRoute());
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onbordData.length,
                  onPageChanged: (value) {
                    setState(() {
                      _pageIndex = value;
                    });
                  },
                  itemBuilder: (context, index) => OnbordingContent(
                    title: _onbordData[index].title,
                    description: _onbordData[index].description,
                    icon: _onbordData[index].icon,
                    isTextOnTop: index.isOdd,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    _onbordData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: defaultPadding / 4),
                      child: DotIndicator(isActive: index == _pageIndex),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageIndex < _onbordData.length - 1) {
                          _pageController.nextPage(
                            curve: Curves.ease,
                            duration: defaultDuration,
                          );
                        } else {
                          AutoRouter.of(context).push(LoginScreenRoute());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.green[700],
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}

class Onbord {
  final IconData icon;
  final String title;
  final String description;

  Onbord({
    required this.icon,
    required this.title,
    this.description = "",
  });
}