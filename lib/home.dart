// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_music.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF969DEE), 
              Color(0xFFC9AFE6), 
              Color(0xFFF6BFDF), 
            ],
            stops: [0.0, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upcoming events',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DEF8), 
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                          Text('in 1 hour', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF969DEE), // Container dalam
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('JUN', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.bold)),
                                const Text('04', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black)),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Zoom Meeting', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                                  SizedBox(height: 4),
                                  Text('07:00 - 08:00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black)),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('To Do list', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                    Text('View all', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.78), fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DEF8), 
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: index == 2 ? 0 : 12),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF969DEE), 
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              'Send prototype to client',
                              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Music', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                    Text('View all', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.78), fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DEF8), 
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Currently Playing:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PlaylistPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF969DEE), 
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[700],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('img', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('SongName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                                        Text('ArtistName', style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6))),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.skip_previous_outlined, color: Colors.black, size: 24),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.pause, color: Color(0xFF969DEE), size: 14),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.skip_next_outlined, color: Colors.black, size: 24),
                                    ],
                                  ),
                                  
                                ],
                              ),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  const Text('01:11', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          Container(
                                            height: 3,
                                            color: Colors.white.withOpacity(0.4),
                                          ),
                                          FractionallySizedBox(
                                            widthFactor: 0.35,
                                            child: Container(
                                              height: 3,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Positioned(
                                            left: MediaQuery.of(context).size.width * 0.18, 
                                            child: Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Text('03:23', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: const Color(0xFFFFE0F2),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home'),
              _buildNavItem(Icons.calendar_month_outlined, 'Calendar'),
              _buildNavItem(Icons.menu_book_outlined, 'Pomodoro'),
              _buildNavItem(Icons.assignment_outlined, 'To Do'),
              _buildNavItem(Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}