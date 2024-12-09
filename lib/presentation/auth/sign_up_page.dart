import 'package:flutter/material.dart';
import 'package:socrates/common/helpers/is_dark_mode.dart';
import 'package:socrates/common/widgets/basic_app_bar.dart';
import 'package:socrates/common/widgets/basic_app_button.dart';
import 'package:socrates/core/configs/assets/app_image.dart';
import 'package:socrates/data/models/auth/create_user_req.dart';
import 'package:socrates/domain/usecases/auth/signup.dart';
import 'package:socrates/presentation/auth/sign_in_page.dart';
import 'package:socrates/presentation/home_page/home_page.dart';
import 'package:socrates/service_locator.dart';

// this is the register page or Sign UP page whatever you want to call it, this is used to register the user in the app.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // this is the text editing controller which is used to get the text from the text field
  final TextEditingController _fullName = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  // this is the build method which is used to build the widget and show it on the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // here's our custom app bar which is used to show the app bar on the top of the screen
      appBar: BasicAppbar(
        hideBack: false,
        title: Image.asset(
          height: 40,
          isDarkMode(context)
              ? AppImage.newWhiteOnBlackLogo
              : AppImage.newBlackOnWhiteLogo,
        ),
      ),
      bottomNavigationBar: _signInText(context),
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
               SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Center(
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode(context) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _nameField(),
                const SizedBox(
                  height: 20,
                ),
                _emailField(),
                const SizedBox(
                  height: 20,
                ),
                _passwordField(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                BasicAppButton(
                  text: 'Create Account',
                  onPressed: () async {
                    //calling the signup use case to create the user
                    if(_formKey.currentState!.validate()){
                      var result = await sl<SignupUseCase>().call(
                      CreateUserReq(
                        fullName: _fullName.text,
                        email: _email.text,
                        password: _password.text,
                      ),
                      // this is the parameter that is passed to the use case to create the user basically things that are needed atleast to create the user.
                      params: CreateUserReq(
                        fullName: _fullName.text.toString(),
                        email: _email.text.toString(),
                        password: _password.text.toString(),
                      ),
                    );
                    // this is the fold when user is not created successfully and the error is shown to the user.
                    result.fold(
                      (l) {
                        var snackBar = SnackBar(
                          content: Text(l.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      // this is the success case where the user is created successfully and the user is redirected to the home page.
                      (r) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const HomePage()),
                        );
                      },
                    );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // this is the sign in text which is used to take the user to the sign in page if the user already has an account.
  Row _signInText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(
            color: isDarkMode(context) ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        // when pressed the user is taken to the sign in page
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignInPage()));
          },
          child: const Text(
            'Sign In',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  // this is the name field which is used to take the name of the user
  Widget _nameField() {
    return TextFormField(
      controller: _fullName,
      decoration: InputDecoration(
        labelText: 'Name',
        hintText: 'Enter your name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name is required';
        }
        return null;
      },
    );
  }

  // this is the email field which is used to take the email of the user
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
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  // this is the password field which is used to take the password of the user
  Widget _passwordField() {
    return TextFormField(
      controller: _password,
      obscureText: _isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
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
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
