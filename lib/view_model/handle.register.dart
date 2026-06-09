import 'package:flutter/widgets.dart';
import 'package:my_study/services/auth_service.dart';

class HandleRegister extends ChangeNotifier{
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

  void setGender(String gender){
    _selectedGender = gender;
    notifyListeners();
  }

  Future<bool> handleRegister() async {
    if(_selectedGender == null ){
      _errorMessage = "Please Input a Gender";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final error = await _authService.register(
  email: emailController.text.trim(),
      password: passwordController.text.trim(),
      username: usernameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      gender: _selectedGender!,
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
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}