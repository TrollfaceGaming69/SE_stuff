import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HandleLogin extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Email and password cannot be empty.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.login(
      email: email,
      password: password,
    );

    _isLoading = false;

    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    _clearControllers();
    notifyListeners();
    return true;
  }

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}