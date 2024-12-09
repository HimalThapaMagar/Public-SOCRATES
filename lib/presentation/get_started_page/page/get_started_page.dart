import 'package:flutter/material.dart';
import 'package:socrates/common/helpers/is_dark_mode.dart';
import 'package:socrates/core/configs/assets/app_image.dart';
import 'package:socrates/core/configs/themes/app_colors.dart';
import 'package:socrates/presentation/choose_mode/page/choose_mode_page.dart';

// this is the GetStarted Page of the app which will be shown to the user when the app is opened for the first time.
// This is just a simple page with a logo and a button to get started. so it is kept stateless and it will not have any state. will be easy on the resources and performance.
class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          // here is the logo of the app shown to the user.
          isDarkMode(context)
              ? Image.asset(AppImage.whiteLogo)
              : Image.asset(AppImage.blackLogo),
          const Spacer(),
          // this is the button to get started, when the user clicks on this button it will take the user to the ChooseModePage. pretty self explanatory I guess.
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChooseModePage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(
                color: AppColors.lightBackground,
                fontSize: 20,
              ),
            ),
          ),
         SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        ],
      ),
    );
  }
}
