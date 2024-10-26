import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase/auth_service.dart';


class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign In", style: TextStyle(color: Colors.amber)),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Email input field
                  TextField(
                    controller: _emailController, // Assign controller
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: Colors.grey[800],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
        
                  // Password input field
                  TextField(
                    controller: _passwordController, // Assign controller
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: Colors.grey[800],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
        
                  // Sign In button
                  ElevatedButton(
                    onPressed: () {
                      _signIn(context); // Call the sign-in method
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      textStyle: TextStyle(color: Colors.white60),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
        
                  // Link to Register
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/register'); // Navigate to Register Screen
                    },
                    child: Text(
                      "Don't have an account? Register here",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn(BuildContext context) async {
    String email = _emailController.text.trim(); // Trim whitespace
    String password = _passwordController.text.trim(); // Trim whitespace

    User? user = await AuthService().loginWithEmailAndPassword(email, password);

    if (user != null) {
      // Sign in successful, navigate to the home screen
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Handle error (show a message to the user)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed. Please check your email and password.')),
      );
    }
  }
}
