import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socrates/common/helpers/is_dark_mode.dart';
import 'package:socrates/common/widgets/basic_app_bar.dart';
import 'package:socrates/common/widgets/basic_app_button.dart';
import 'package:socrates/core/configs/assets/app_image.dart';

// This page allows users to reset their password by sending a password reset email to their email address if it exists in the system. otherwise it will not send the reset email but will not show an error message incase somebody tries to bruteforce the system I guess so it is also a security measure.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // this is the contoller for the email field that is used to get the email from the user fromt the UI.
  final TextEditingController _email = TextEditingController();
  // this is the firebase auth instance that is used to send the password reset email to the user.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // this function is used to reset the password of the user by sending a password reset email to the user.
  Future<void> _resetPassword() async {
    if (_email.text.trim().isEmpty) {
      _showErrorDialog('Please enter an email address');
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to send password reset email
      await _auth.sendPasswordResetEmail(email: _email.text.trim());
      // Show success dialog
      _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      String errorMessage = 'An error occurred';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many reset attempts. Please try again later.';
          break;
        default:
          errorMessage = e.message ?? 'An unexpected error occurred';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      // Handle any other unexpected errors
      _showErrorDialog('An unexpected error occurred');
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Reset'),
          content: Text(
            'If this user exists, A password reset link has been sent to ${_email.text.trim()}. '
            'Please check your email to reset your password.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _emailField(),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : BasicAppButton(
                      onPressed: _resetPassword,
                      text: "Reset Password",
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // this is that emailfield
  Widget _emailField() {
    return TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        // Basic email validation
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      // this is the autovalidate mode that is used to validate the email field when the user interacts with the field.
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
