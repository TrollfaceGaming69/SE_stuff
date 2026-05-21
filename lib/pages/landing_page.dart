import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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

          
        ],
      ),
    );
  }
}