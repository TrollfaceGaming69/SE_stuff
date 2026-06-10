import 'package:flutter/widgets.dart';
import 'package:my_study/services/auth_service.dart';

class HandleRegister extends ChangeNotifier {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _selectedGender;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedGender => _selectedGender;

  void setGender(String gender) {
    _selectedGender = gender;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();
    final phone = phoneController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      _errorMessage = "All fields are required.";
      notifyListeners();
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _errorMessage = "Please enter a valid email address.";
      notifyListeners();
      return false;
    }

    if (password.length < 8) {
      _errorMessage = "Password must be at least 8 characters.";
      notifyListeners();
      return false;
    }

    if (_selectedGender == null) {
      _errorMessage = "Please select a gender.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.register(
      email: email,
      password: password,
      username: username,
      phoneNumber: phone,
      gender: _selectedGender!,
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
    phoneController.clear();
    usernameController.clear();
    passwordController.clear();
    _selectedGender = null;
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}