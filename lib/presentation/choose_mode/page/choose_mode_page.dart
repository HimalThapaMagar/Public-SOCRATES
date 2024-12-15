import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:socrates/common/helpers/is_dark_mode.dart';
import 'package:socrates/core/configs/assets/app_animations.dart';
import 'package:socrates/core/configs/themes/app_colors.dart';
import 'package:socrates/presentation/auth/singin_or_signup_page.dart';
import 'package:socrates/presentation/choose_mode/bloc/theme_cubit.dart';

// this is statefull widget because it needs to change the animation or state of the widget to show animation of the light mode to dark mode and vice versa I guess.
class ChooseModePage extends StatefulWidget {
  const ChooseModePage({super.key});

  @override
  State<ChooseModePage> createState() => _ChooseModePageState();
}

// this has the SingleTickerProviderStateMixin which is used to animate the lottie animation in the widget which provides the ticker for the animation controller
class _ChooseModePageState extends State<ChooseModePage>
    with SingleTickerProviderStateMixin {
  // this is the animation controller which is used to control the animation of the lottie animation
  late final AnimationController _controller;
  // this is the boolean value which is used to check the dark mode or light mode
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController for controlling the Lottie animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  // this is the method which is used to check the theme of the app and set the boolean value of the _isDarkMode this is called when the theme is changed
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now it's safe to use context to check the theme
    _isDarkMode = isDarkMode(context);
  }

  // this function is used to toggle the theme of the app from dark mode to light mode and vice versa as the freaking name suggests.
  void _toggleTheme() {
    // setstate is used to change the state of the widget and rebuild the widget with the new state
    setState(() {
      // this changes the boolean value of the _isDarkMode to the opposite of the current value that means if it is true it will be false and vice versa
      _isDarkMode = !_isDarkMode;

      // Play animation forward if switching to dark mode, backward if switching to light mode
      if (_isDarkMode) {
        _controller
            .forward()
            .then((_) => _controller.stop()); // Play forward to the end
      } else {
        _controller
            .reverse()
            .then((_) => _controller.stop()); // Play backward to the start
      }
    });
  }

  // this is the build method of the widget which is used to build the widget and show the widget on the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Choose Mode",
                style: TextStyle(
                  fontSize: 24,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              // this is the lottie animation which is used to show the animation of the light mode to dark mode and vice versa
              Lottie.asset(
                AppAnimations.chooseModeAnimation,
                controller: _controller,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Light Mode Button
                  ElevatedButton(
                    onPressed: !_isDarkMode
                        ? null // Disable button if already in light mode
                        : () {
                            context
                                .read<ThemeCubit>()
                                .updateTheme(ThemeMode.light);
                            _toggleTheme();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                    ),
                    child: const Text("Light Mode",
                        style: TextStyle(color: Colors.black)),
                  ),
          
                  // Dark Mode Button
                  ElevatedButton(
                    onPressed: _isDarkMode
                        ? null // Disable button if already in dark mode
                        : () {
                            context
                                .read<ThemeCubit>()
                                .updateTheme(ThemeMode.dark);
                            _toggleTheme();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDarkMode ? Colors.white : Colors.black,
                    ),
                    child: const Text(
                      "Dark Mode",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // this is the button which is used to navigate to the signup or signin page
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupOrSigninPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: AppColors.lightBackground,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // this is used to dispose the animation controller when the widget is disposed to avoid memory leaks
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
