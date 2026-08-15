// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:routefixer/constants.dart';
import 'package:routefixer/widgets/app_button.dart';
import 'package:routefixer/widgets/app_inputfield.dart';
import '../services/auth_service.dart';

class AdminSignup extends StatefulWidget {
  const AdminSignup({super.key});

  @override
  State<AdminSignup> createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {
  final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _securityKeycontroller = TextEditingController();

  static const String _requiredSecurityKey = "ADMIN123";

  Future<void> _signup() async {
    String email = _emailcontroller.text.trim();
    String password = _passwordcontroller.text.trim();
    String name = _namecontroller.text.trim();
    String securityKey = _securityKeycontroller.text.trim();

    if (securityKey != _requiredSecurityKey) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Admin Security Key!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      User? user = await _authService.signup(email, password, name);
      if (user != null) {
        // Save the registered email persistently as an allowed admin email
        final prefs = await SharedPreferences.getInstance();
        final List<String> currentAdmins = prefs.getStringList('registered_admins') ?? [];
        if (!currentAdmins.contains(email)) {
          currentAdmins.add(email);
          await prefs.setStringList('registered_admins', currentAdmins);
        }

        debugPrint("Admin signed up successfully: ${user.email}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Administrative account successfully registered!'),
            backgroundColor: Colors.green,
          ),
        );
        context.goNamed('mainpage');
      }
    } catch (e) {
      debugPrint("Admin Sign up failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Admin Registration Failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RouteFixer'),
        leading: IconButton(
          onPressed: () => context.goNamed('intro'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.all(30),
          width: double.infinity,
          height: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Admin Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Name
                          AppInputField(
                            label: "Name",
                            controller: _namecontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Email
                          AppInputField(
                            label: "Email",
                            controller: _emailcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!value.contains('@')) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Password
                          AppInputField(
                            label: 'Password',
                            controller: _passwordcontroller,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Admin Security Key
                          AppInputField(
                            label: 'Admin Security Key',
                            controller: _securityKeycontroller,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the Admin Security Key";
                              }
                              if (value != _requiredSecurityKey) {
                                return "Incorrect Admin Security Key";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 25),

                          // Sign Up Button
                          AppElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                _signup();
                              }
                            },
                            label: 'Register Admin',
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30,
                            ),
                          ),

                          Divider(
                            color: Colors.grey.shade400,
                            thickness: 2,
                            height: 40,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already registered?",
                                style: TextStyle(fontSize: 16),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.goNamed('admin_login');
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
