import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'home_screen.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController =
    TextEditingController();

final TextEditingController passwordController =
    TextEditingController();

final TextEditingController confirmPasswordController =
    TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
     body: Padding(
  padding: const EdgeInsets.all(20),
  child: Form(
    key: _formKey,
    child: Column(
      children: [
        TextFormField(
  controller: emailController,
  decoration: const InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }

    return null;
  },
),

const SizedBox(height: 15),

TextFormField(
  controller: passwordController,
  obscureText: true,
  decoration: const InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  },
),
const SizedBox(height: 15),

TextFormField(
  controller: confirmPasswordController,
  obscureText: true,
  decoration: const InputDecoration(
    labelText: 'Confirm Password',
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  },
),
const SizedBox(height: 20),

ElevatedButton(
onPressed: () async {
  if (_formKey.currentState!.validate()) {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

     Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const MainScreen(),
  ),
);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'An account already exists with this email.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Your password is too weak.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Please enter a valid email address.';
        } else {
          errorMessage = 'Something went wrong. Please try again.';
        }
      });
    }
  }
},
  child: const Text('Sign Up'),
),
const SizedBox(height: 20),

if (errorMessage != null)
  Text(
    errorMessage!,
    style: const TextStyle(
      color: Colors.red,
    ),
  ),
const SizedBox(height: 10),

TextButton(
  onPressed: () {
    Navigator.pop(context);
  },
  child: const Text('Already have an account? Login'),
),
      ],
    ),
  ),
),
    );
  }
  @override
void dispose() {
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();

  super.dispose();
}
}