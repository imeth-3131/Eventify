import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _batchController = TextEditingController();
  final _universityController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _batchController.dispose();
    _universityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final authService = context.read<AuthService>();
      final userService = context.read<UserService>();
      final credential = await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = credential.user?.uid;
      if (uid == null) throw Exception('User id not found after signup.');

      await userService.createUserProfile(
        uid: uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        age: _ageController.text.trim(),
        batch: _batchController.text.trim(),
        university: _universityController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = _passwordController.text;
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasDigit = password.contains(RegExp(r'\d'));

    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: 'Name',
                    validator: (value) => Validators.requiredField(value, 'Name'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _ageController,
                    label: 'Age',
                    keyboardType: TextInputType.number,
                    validator: (value) => Validators.requiredField(value, 'Age'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _batchController,
                    label: 'Batch',
                    validator: (value) => Validators.requiredField(value, 'Batch'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _universityController,
                    label: 'University',
                    validator: (value) => Validators.requiredField(value, 'University'),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(hasUpper ? Icons.check_circle : Icons.radio_button_unchecked),
                      const SizedBox(width: 8),
                      const Text('Contains uppercase letter'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(hasDigit ? Icons.check_circle : Icons.radio_button_unchecked),
                      const SizedBox(width: 8),
                      const Text('Contains number'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Sign up',
                    onPressed: _signUp,
                    loading: _loading,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
