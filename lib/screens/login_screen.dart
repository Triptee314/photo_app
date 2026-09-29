import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'signup_screen.dart';
import 'home_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),
              Form(
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
          ],
        ),
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

            ElevatedButton(
             onPressed: () async {
  if (_formKey.currentState!.validate()) {
     setState(() {
        errorMessage = null;
      });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
        if (e.code == 'invalid-credential') {
          errorMessage = 'Incorrect email or password.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Please enter a valid email address.';
        } else {
          errorMessage = 'Something went wrong. Please try again.';
        }
      });
    }
  }
},
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),

TextButton(
  onPressed: () {
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const SignupScreen(),
  ),
);
  },
  child: const Text("Don't have an account? Sign Up"),
),
          ],
        ),
      ),
    );
  }
}

