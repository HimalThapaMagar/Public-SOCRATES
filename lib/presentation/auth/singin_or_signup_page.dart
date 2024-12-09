import 'package:flutter/material.dart';
import 'package:socrates/common/helpers/is_dark_mode.dart';
import 'package:socrates/common/widgets/basic_app_bar.dart';
import 'package:socrates/common/widgets/basic_app_button.dart';
import 'package:socrates/core/configs/assets/app_image.dart';
import 'package:socrates/presentation/auth/sign_in_page.dart';
import 'package:socrates/presentation/auth/sign_up_page.dart';

// this is the stateless widget which is used to show the sign in or sign up page of the app, basically used to show if the user is already registered or not and give them choice to register or sign in
class SignupOrSigninPage extends StatelessWidget {
  const SignupOrSigninPage({super.key});
  // this is the build method which is used to build the widget and show it on the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // this is our custom app bar which is used to show the app bar on the top of the screen
          const BasicAppbar(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      children: [
                        // this checks if the dark mode is enabled or not and shows the logo accordingly
                        isDarkMode(context)
                            ? Image.asset(
                                AppImage.whiteLogo,
                              )
                            : Image.asset(
                                AppImage.blackLogo,
                              ),
                        // this is just a simple text widget which shows the name of the project
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        const Text(
                          "This project is designed to help the enumerators and the supervisors to collect data in the field",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                       SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        Row(
                          children: [
                            // this is the register button which is used to take the user to the register page
                            Expanded(
                              child: BasicAppButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  SignUpPage()));
                                  },
                                  text: "Register"),
                            ),
                            const SizedBox(width: 20),
                            // this is the sign in button which is used to take the user to the sign in page
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
                                },
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
