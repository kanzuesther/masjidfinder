import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:masjidfinder/utility/shareprferences.dart';
import 'package:provider/provider.dart';

import 'package:masjidfinder/routes/app_router.dart';

import 'database/user_db/user_controller.dart';
@RoutePage(name: 'SplashScreenRoute')
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  CustomSharePreference prefs = CustomSharePreference();
  final log = Logger();

  void checkToken() async {
    try {
      String? token = await prefs.getPreferenceValue("user");

      if (token != null) {
        final userController = context.read<UserController>();
        await userController.initializeCurrentUser();
        log.e(userController.currentUser?.userId);
        log.e('Token exists, navigating to EntryPointRoute');
        AutoRouter.of(context).replace(EntryPointRoute());
      } else {
        log.e('No token found, navigating to OnboardingScreenRoute');
        AutoRouter.of(context).replace(OnboardingScreenRoute());
      }
    } catch (e) {
      log.e('Error checking token: $e');
      AutoRouter.of(context).replace(OnboardingScreenRoute());
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      checkToken();
    });
  }

  Widget _buildSplashContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              Icons.mosque,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20),
        FadeTransition(
          opacity: _animation,
          child: Text(
            'MasjidFinder',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SizedBox(height: 10),
        FadeTransition(
          opacity: _animation,
          child: Text(
            'Locate Your Nearest Mosque',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A6D92), // Islamic-inspired blue color
      body: Center(
        child: _buildSplashContent(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}