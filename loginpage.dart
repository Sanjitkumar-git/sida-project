import 'package:flutter/material.dart';
import 'forgotpassword.dart';
import 'register.dart';
import 'confirmation_code_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.image, size: 60, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Heading
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Login Form
            const LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Email
          TextFormField(
            decoration: const InputDecoration(labelText: "Email"),
            onChanged: (value) => email = value,
            validator: (value) =>
            value!.isEmpty ? "Please enter email" : null,
          ),

          // Password
          TextFormField(
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
            onChanged: (value) => password = value,
            validator: (value) =>
            value!.isEmpty ? "Please enter password" : null,
          ),

          // Forgot Password
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage(),
                  ),
                );
              },
              child: const Text("Forgot Password?"),
            ),
          ),

          const SizedBox(height: 20),

          // Login Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                debugPrint("Email: $email, Password: $password");


                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfirmationCodePage(),
                  ),
                );
              }
            },
            child: const Text("Login"),
          ),

          const SizedBox(height: 20),

          // Register Option
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Not a member? "),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text("Register now"),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Social Login
          const Text(
            "Or connect with",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.g_mobiledata,
                    size: 40, color: Colors.red),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Google login demo")),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.facebook,
                    size: 40, color: Colors.blue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Facebook login demo")),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.apple,
                    size: 40, color: Colors.black),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Apple login demo")),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
