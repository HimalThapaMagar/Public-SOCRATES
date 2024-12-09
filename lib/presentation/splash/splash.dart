import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socrates/common/helpers/is_dark_mode.dart';
import 'package:socrates/core/configs/assets/app_image.dart';
import 'package:socrates/presentation/get_started_page/page/get_started_page.dart';
import 'package:socrates/presentation/home_page/home_page.dart';

// this is the splash screen of the app
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // this init state will be called when the widget is created and it will call the checkauthstatus function.
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // this is just a simple widget that will show the logo of the app for now, we can add more stuff to it later.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isDarkMode(context)
            ? Image.asset(AppImage.whiteLogo)
            : Image.asset(AppImage.blackLogo),
      ),
    );
  }

  // This function will redirect the user immediately to the GetStartedPage.
  Future<void> redirect() async {
    // Directly navigate to the GetStartedPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const GetStartedPage(),
      ),
    );
  }

  // this function is used to see if the user is already logged in or not, if the user is logged in then it will redirect the user to the home page otherwise it will redirect the user to the get started page.
  Future<void> _checkAuthStatus() async {
    // Simulate splash screen delay
    await Future.delayed(const Duration(seconds: 1));

    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    // Ensure the context is still valid before navigating
    if (!mounted) return;

    // If user is not null, navigate to home, else navigate to sign-in
    if (user != null) {
      // User is already signed in, navigate to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // User is not signed in, navigate to login
      redirect();
    }
  }
}
