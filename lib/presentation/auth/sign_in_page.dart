import 'package:flutter/material.dart';
import 'package:socrates/common/helpers/is_dark_mode.dart';
import 'package:socrates/common/widgets/basic_app_bar.dart';
import 'package:socrates/common/widgets/basic_app_button.dart';
import 'package:socrates/core/configs/assets/app_image.dart';
import 'package:socrates/data/models/auth/sign_in_user_req.dart';
import 'package:socrates/domain/usecases/auth/signin.dart';
import 'package:socrates/presentation/auth/forgot_password_page.dart';
import 'package:socrates/presentation/auth/sign_up_page.dart';
import 'package:socrates/presentation/home_page/home_page.dart';
import 'package:socrates/service_locator.dart';

// this is the sign in page of the app, this is used to sign in the user in the app. but if the user is already signed in then the app will redirect to home page and this page will not be shown. that was handled by the splash page I think.
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // this is the text editing controller which is used to get the text from the text field like email and password in here
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // tracking the password visibility
  bool _isPasswordVisible = false;
  // tracking the form key
  final _formKey = GlobalKey<FormState>();

  // this is the build method which is used to build the widget and show it on the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBack: false,
        title: Image.asset(
          height: 40,
          isDarkMode(context)
              ? AppImage.newWhiteOnBlackLogo
              : AppImage.newBlackOnWhiteLogo,
        ),
      ),
      bottomNavigationBar: _signupText(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode(context) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                _emailField(),
                const SizedBox(
                  height: 20,
                ),
                _passwordField(),
                const SizedBox(
                  height: 40,
                ),
                BasicAppButton(
                  text: 'Sign In',
                  onPressed: () async {
                    // this is the validation of the form, if the form is validated then the user will be signed in otherwise the error will be shown to the user.
                    if (_formKey.currentState!.validate()) {
                      var result = await sl<SigninUseCase>().call(
                        SigninUserReq(
                          email: _email.text,
                          password: _password.text,
                        ),
                        params: SigninUserReq(
                          email: _email.text.toString(),
                          password: _password.text.toString(),
                        ),
                      );
                      result.fold((l) {
                        var snackBar = SnackBar(
                          content: Text(l.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (r) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const HomePage()),
                        );
                      });
                    }
                  },
                ),
                _forgotPassword(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // this is the widget for the forgot password text, this is used to take the user to the forgot password page.
  Align _forgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
          },
          child: const Text("Forgot Password?")),
    );
  }

  Row _signupText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not a member?',
          style: TextStyle(
            color: isDarkMode(context) ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignUpPage()));
          },
          child: const Text(
            'Register Now',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _email,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      // checking if the email is valid or not, the email should not be empty and should be in the correct format.
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _password,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 10.0),
          child: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
