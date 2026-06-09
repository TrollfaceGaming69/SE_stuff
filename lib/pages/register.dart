import 'package:flutter/material.dart';
import 'login.dart';
import "../view_model/handle.register.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _viewModel = HandleRegister();

  @override
  void dispose(){
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async{
    final success = await _viewModel.handleRegister();
    if(!mounted) return;

    if(success){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())
      );
    }
    else{
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 0.9],
                colors: [
                  Color(0xFF444B9D),
                  Color(0xFF6D439B),
                  Color(0xFFD784B4),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 32.0),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Create\nAccount',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            _buildInputField('E-mail', 'Email',
                                controller: _viewModel.emailController),
                            _buildInputField('Phone Number', 'Phone Number',
                                controller: _viewModel.phoneController),
                            _buildInputField('Username', 'Username',
                                controller: _viewModel.usernameController),
                            _buildInputField('Password', 'Password',
                                controller: _viewModel.passwordController,
                                isPassword: true),

                            const Text('Gender',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildGenderButton('Man', Icons.male),
                                const SizedBox(width: 16),
                                _buildGenderButton('Woman', Icons.female),
                              ],
                            ),

                            if (_viewModel.errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _viewModel.errorMessage!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13),
                              ),
                            ],

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _viewModel.isLoading
                                    ? null
                                    : _onRegisterPressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF192B9A),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _viewModel.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Register',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                ),
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text: 'Login here',
                                        style: TextStyle(
                                          color: Color(0xFF192B9A),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, bottom: 24.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Back',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    final isSelected = _viewModel.selectedGender == gender;
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
          _viewModel.setGender(gender);
          setState(() {});
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(gender, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xFF192B9A) : Colors.grey.shade400,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint,
      {bool isPassword = false, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: isPassword,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF192B9A)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}