// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  final Color color0 = const Color(0xFF969DEE);
  final Color color50 = const Color(0xFFC9AFE6);
  final Color color90 = const Color(0xFFF6BFDF);
  final Color colorMainContainer = const Color(0xFFE8DEF8);
  final Color colorInnerContainer = const Color(0xFF969DEE);
  final Color colorButton = const Color(0xFF4E207E);
  final Color colorNavBar = const Color(0xFFFFE0F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color0, color50, color90],
            stops: const [0.0, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 30),

                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1D1D1), 
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 2),
                  ),
                  child: Center(
                    child: Image.asset('lib/assets/images/song_logo.png', width: 140, height: 140),
                  ),
                ),

                const SizedBox(height: 30),

                _buildMainContainer(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Text(
                            "Rainy Lofi City - Lofi",
                            style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          const Icon(Icons.music_note, size: 18),
                        ],
                      ),
                      const SizedBox(height: 10),
  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shuffle, size: 20),
                          SizedBox(width: 15),
                          Icon(Icons.skip_previous, size: 24),
                          SizedBox(width: 15),
                          Icon(Icons.pause_circle_filled, size: 36),
                          SizedBox(width: 15),
                          Icon(Icons.skip_next, size: 24),
                          SizedBox(width: 15),
                          Icon(Icons.repeat, size: 20),
                        ],
                      ),

                      Slider(
                        value: 0.8,
                        onChanged: (v) {},
                        activeColor: Colors.black54,
                        inactiveColor: Colors.black12,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorButton,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      "Link Your Playlists Here!",
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                _buildPlatformCard(
                  logo: Image.asset('lib/assets/images/spotify_logo.png', width: 40, height: 40),
                  platformName: "Spotify",
                  bgColor: colorButton,
                ),

                const SizedBox(height: 25),

                _buildPlatformCard(
                  logo: Image.asset('lib/assets/images/yt_logo.png', width: 40, height: 40),
                  platformName: "Youtube",
                  bgColor: colorButton,
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorMainContainer,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _buildPlatformCard({
    required Widget logo,
    required String platformName,
    required Color bgColor,
  }) {
    return _buildMainContainer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                logo,
                const SizedBox(width: 10),
                Text(
                  platformName,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: colorInnerContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "https://......................................................",
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}