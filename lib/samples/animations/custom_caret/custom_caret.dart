import 'package:flutter/material.dart';
import 'package:flutter_samples/samples/animations/custom_caret/max_length.dart';
import 'package:flutter_samples/samples/animations/custom_caret/password_strength.dart';

class CustomCaret extends StatefulWidget {
  const CustomCaret({super.key});

  static const String route = '/animations/custom-caret';

  @override
  State<CustomCaret> createState() => _CustomCaretState();
}

class _CustomCaretState extends State<CustomCaret> {
  final _nameController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CaretMaxLength(
                      maxLength: 10, inputController: _nameController),
                  const SizedBox(height: 16),
                  PasswordStrength(
                      maxLength: 8, inputController: _passController)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
