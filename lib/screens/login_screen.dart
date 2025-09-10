import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:nirva_app/home_page.dart';
import 'package:nirva_app/services/native_s3_bridge.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _logger = Logger();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user object from form data
      final user = User(
        id: "", // Will be populated from server response
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        displayName: _usernameController.text.split('@').first, // Use email prefix as display name
      );

      // Attempt login
      final token = await NirvaAPI.login(user);
      
      if (token == null || token.access_token.isEmpty) {
        throw Exception('Invalid credentials');
      }

      _logger.i('Login successful for user: ${user.username}');
      
      // Update user provider with logged in user data
      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(user);
      }

      // Update user context (timezone and locale) after successful login
      try {
        _logger.i('Updating user context...');
        await NirvaAPI.updateContext();
        _logger.i('User context updated successfully');
      } catch (e) {
        _logger.w('Failed to update user context: $e');
        // Don't fail the login process if context update fails
      }

      // Fetch S3 credentials after successful login
      try {
        _logger.i('Fetching S3 upload credentials...');
        await NativeS3Bridge.instance.refreshCredentialsIfNeeded();
        _logger.i('S3 credentials fetch initiated');
      } catch (e) {
        _logger.w('Failed to fetch S3 credentials on login: $e');
        // Don't fail the login process if S3 credentials fail
      }

      // Navigate to home page
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomePage(title: 'Nirva App Home Page'),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    } catch (e) {
      _logger.e('Login failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Title
                const Text(
                  'NIRVA',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E3C26),
                    fontFamily: 'Georgia',
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 48),

                // Login Form
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Username field
                        TextFormField(
                          controller: _usernameController,
                          enabled: !_isLoading,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: const TextStyle(
                              color: Color(0xFF0E3C26),
                              fontFamily: 'Georgia',
                            ),
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF0E3C26),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0E3C26),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFfaf9f5).withOpacity(0.5),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Color(0xFF0E3C26),
                              fontFamily: 'Georgia',
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF0E3C26),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF0E3C26),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF0E3C26),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFfaf9f5).withOpacity(0.5),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                        ),
                        const SizedBox(height: 32),

                        // Login button
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFe7bf57),
                                Color(0xFFd4a843),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFe7bf57).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isLoading ? null : _handleLogin,
                              borderRadius: BorderRadius.circular(16),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Georgia',
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Footer text
                Text(
                  'Your personal AI companion',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}