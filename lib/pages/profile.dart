import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const ProfileScreen({Key? key, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final AuthService authService = AuthService();

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Not logged in',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 0.9],
            colors: [
              Color(0xFF444B9D),
              Color(0xFF6D439B),
              Color(0xFFD784B4),
            ],
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('users').doc(user.uid).snapshots(),
          builder: (context, snapshot) {
            String username = 'User';
            String email = user.email ?? 'No email';

            if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              username = data?['username'] ?? 'User';
              email = data?['email'] ?? user.email ?? 'No email';
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F0F4), 
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(40), 
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      20,
                      MediaQuery.of(context).padding.top + 10,
                      20,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF5C57A5),
                            size: 32,
                          ),
                          onPressed: () {
                            onBack?.call();
                          },
                        ),
                        const SizedBox(height: 10),

                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFB0B0B0),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  username.isNotEmpty ? username[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F0F4),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF00116D),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit_square,
                                    color: Color(0xFF00116D), 
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              color: Color(0xFF00116D), 
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF00116D),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  color: Color(0xFF00116D), 
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Icon(
                                Icons.edit_square,
                                color: Color(0xFF00116D),
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'App Settings',
                          style: TextStyle(
                            color: Color(0xFFF2F0F4), 
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildSettingsContainer(
                          children: [
                            _buildSettingItem(Icons.wb_sunny_outlined, 'Appearance & Theme'),
                            _buildDivider(),
                            _buildSettingItem(Icons.accessibility_new, 'Accessibility'),
                            _buildDivider(),
                            _buildSettingItem(Icons.notifications_none_outlined, 'Notification'),
                            _buildDivider(),
                            _buildSettingItem(Icons.volume_up_outlined, 'Sound'),
                            _buildDivider(),
                            _buildSettingItem(Icons.language, 'Language'),
                            _buildDivider(),
                            _buildSettingItem(Icons.feedback_outlined, 'Feedback'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'Account Settings',
                          style: TextStyle(
                            color: Color(0xFFF2F0F4),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildSettingsContainer(
                          children: [
                            _buildSettingItem(Icons.vpn_key_outlined, 'Password'),
                            _buildDivider(),
                            _buildSettingItem(
                              Icons.mail_outline, 
                              'Email Address: $email'
                            ),
                            _buildDivider(),
                            _buildSettingItem(
                              Icons.logout, 
                              'Log out',
                              onTap: () async {
                                await authService.logout();
                                if (context.mounted) {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F0F4).withOpacity(0.7), 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFF2F0F4), 
                size: 26,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFF2F0F4), 
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: const Color(0xFFF2F0F4).withOpacity(0.4),
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}