// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'home_music.dart';
import '../model/shared_data.dart';
import '../services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onTabRedirect;
  
  const HomeScreen({super.key, this.onTabRedirect});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoService _todoService = TodoService();

  @override
  Widget build(BuildContext context) {
    Map<String, String>? featuredEvent;
    if (globalEventsMap["2026-06-04"] != null && globalEventsMap["2026-06-04"]!.isNotEmpty) {
      featuredEvent = globalEventsMap["2026-06-04"]![0];
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                
                GestureDetector(
                  onTap: () => widget.onTabRedirect?.call(1),
                  child: Container(
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
                            color: const Color(0xFF969DEE), 
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text('JUN', style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold)),
                                  Text('04', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black)),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      featuredEvent != null ? featuredEvent["title"]! : 'No Schedule Scheduled', 
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      featuredEvent != null ? featuredEvent["time"]! : '00:00 - 00:00', 
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('To Do list', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                    GestureDetector(
                      onTap: () => widget.onTabRedirect?.call(3),
                      child: Text('View all', style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.78), fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                StreamBuilder<List<Todo>>(
                  stream: _todoService.todosStream(),
                  builder: (context, snapshot) {
                    final todos = snapshot.data ?? [];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DEF8), 
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: todos.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  'No tasks yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                todos.length > 3 ? 3 : todos.length, 
                                (index) {
                                  final item = todos[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: index == 2 || index == todos.length - 1 ? 0 : 12),
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
                                          child: item.isDone 
                                              ? const Icon(Icons.check, size: 18, color: Color(0xFF030A59))
                                              : null,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            item.text,
                                            style: TextStyle(
                                              fontSize: 16, 
                                              color: Colors.black, 
                                              fontWeight: FontWeight.w500,
                                              decoration: item.isDone ? TextDecoration.lineThrough : TextDecoration.none
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                              }),
                            ),
                    );
                  },
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
    );
  }
}