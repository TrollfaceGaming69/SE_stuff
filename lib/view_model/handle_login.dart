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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim()
    );

    _isLoading = false;

    if(error != null){
      _errorMessage = error;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}