import 'package:flutter/material.dart';
import 'package:socrates/common/helpers/is_dark_mode.dart';
import 'package:socrates/common/widgets/basic_app_bar.dart';
import 'package:socrates/common/widgets/basic_app_button.dart';
import 'package:socrates/core/configs/assets/app_image.dart';
import 'package:socrates/presentation/auth/sign_in_page.dart';
import 'package:socrates/presentation/auth/sign_up_page.dart';

class SignupOrSigninPage extends StatelessWidget {
  const SignupOrSigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BasicAppbar(),
          SafeArea(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate logo size based on screen constraints
                  double logoSize =
                      constraints.maxWidth * 0.9;
                  double maxLogoSize =
                      250; // Maximum logo size to prevent overflow

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Logo with controlled sizing
                          isDarkMode(context)
                              ? Image.asset(
                                  AppImage.whiteLogo,
                                  height: logoSize > maxLogoSize
                                      ? maxLogoSize
                                      : logoSize,
                                )
                              : Image.asset(
                                  AppImage.blackLogo,
                                  height: logoSize > maxLogoSize
                                      ? maxLogoSize
                                      : logoSize,
                                ),

                          // Project Name
                          Text(
                            'Project SOCRATES',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode(context)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Project Description
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "This project is designed to help the enumerators and the supervisors to collect data in the field",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Buttons
                          _buildButtons(context, constraints),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, BoxConstraints constraints) {
    // For very narrow screens, use a column layout
    if (constraints.maxWidth < 350) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: BasicAppButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage())),
              text: "Register",
            ),
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignInPage())),
            child: Text(
              "Sign In",
              style: TextStyle(
                color: isDarkMode(context) ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    }

    // Default row layout for wider screens
    return Row(
      children: [
        Expanded(
          child: BasicAppButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpPage())),
            text: "Register",
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignInPage())),
            child: Text(
              "Sign In",
              style: TextStyle(
                color: isDarkMode(context) ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
