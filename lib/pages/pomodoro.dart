import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

// --- 1. Global Timer Service (Robust Singleton) ---
class PomodoroTimerService extends ChangeNotifier {
  // Safe static instance initialized immediately
  static final PomodoroTimerService instance = PomodoroTimerService._internal();

  PomodoroTimerService._internal();

  Duration totalDuration = const Duration(hours: 2);
  Duration studyDuration = const Duration(minutes: 25);
  Duration breakDuration = const Duration(minutes: 5);

  Duration currentSessionRemaining = const Duration(minutes: 25);
  Duration totalRemaining = const Duration(hours: 2);

  bool isStudyPhase = true;
  bool isRunning = false;
  Timer? _timer;

  void resetTimers() {
    totalRemaining = totalDuration;
    currentSessionRemaining = studyDuration;
    isStudyPhase = true;
    isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void startTimer() {
    if (isRunning) return;
    
    isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (totalRemaining.inSeconds > 0) {
        totalRemaining -= const Duration(seconds: 1);

        if (currentSessionRemaining.inSeconds > 0) {
          currentSessionRemaining -= const Duration(seconds: 1);
        } else {
          isStudyPhase = !isStudyPhase;
          currentSessionRemaining = isStudyPhase ? studyDuration : breakDuration;
        }
      } else {
        timer.cancel();
        isRunning = false;
        currentSessionRemaining = Duration.zero;
      }
      notifyListeners();
    });
  }

  void pauseTimer() {
    if (!isRunning) return;
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void updateDurations({Duration? total, Duration? study, Duration? breakDur}) {
    if (total != null) totalDuration = total;
    if (study != null) studyDuration = study;
    if (breakDur != null) breakDuration = breakDur;
    resetTimers();
  }
}

// --- 2. Pomodoro Screen UI ---
class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // --- Colors ---
  final Color bgTopColor = const Color(0xFF5A53A0);
  final Color bgBottomColor = const Color(0xFFD688AB);
  final Color cardColor = const Color(0xFFF2F2F6);
  final Color boxColor = const Color(0xFFBCC0DC);
  final Color darkBlueColor = const Color(0xFF030A59);

  // Safely point to the initialized static instance
  PomodoroTimerService get _timerService => PomodoroTimerService.instance;

  @override
  void initState() {
    super.initState();
    _timerService.addListener(_updateUI);
  }

  @override
  void dispose() {
    _timerService.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  String _formatTwoDigits(int n) => n.toString().padLeft(2, '0');

  void _showTimePicker(String title, Duration initialTimer, ValueChanged<Duration> onTimerChanged) {
    Duration tempDuration = initialTimer;
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                    ),
                    Text(title, style: TextStyle(color: darkBlueColor, fontWeight: FontWeight.bold, fontSize: 18)),
                    TextButton(
                      onPressed: () {
                        onTimerChanged(tempDuration);
                        Navigator.pop(context);
                      },
                      child: Text('Done', style: TextStyle(color: darkBlueColor, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  initialTimerDuration: initialTimer,
                  onTimerDurationChanged: (Duration newDuration) {
                    tempDuration = newDuration;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxSeconds = _timerService.isStudyPhase 
        ? _timerService.studyDuration.inSeconds.toDouble() 
        : _timerService.breakDuration.inSeconds.toDouble();
        
    double currentProgress = maxSeconds > 0 
        ? _timerService.currentSessionRemaining.inSeconds / maxSeconds 
        : 0.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTopColor, bgBottomColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                _buildTimeCard(
                  title: 'How long are you going to study?',
                  duration: _timerService.totalDuration,
                  onTap: () {
                    if (_timerService.isRunning) return; 
                    _showTimePicker('Total Duration', _timerService.totalDuration, (newDuration) {
                      _timerService.updateDurations(total: newDuration);
                    });
                  },
                ),

                _buildTimeCard(
                  title: 'Study Session',
                  duration: _timerService.studyDuration,
                  onTap: () {
                    if (_timerService.isRunning) return;
                    _showTimePicker('Study Session', _timerService.studyDuration, (newDuration) {
                      _timerService.updateDurations(study: newDuration);
                    });
                  },
                ),

                _buildTimeCard(
                  title: 'Break Session',
                  duration: _timerService.breakDuration,
                  onTap: () {
                    if (_timerService.isRunning) return;
                    _showTimePicker('Break Session', _timerService.breakDuration, (newDuration) {
                      _timerService.updateDurations(breakDur: newDuration);
                    });
                  },
                ),

                const SizedBox(height: 30),

                Text(
                  _timerService.isStudyPhase ? "Focus Time" : "Take a Break!",
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
                const SizedBox(height: 10),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: currentProgress,
                        strokeWidth: 6,
                        color: Colors.white,
                        backgroundColor: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    Text(
                      "${_formatTwoDigits(_timerService.currentSessionRemaining.inMinutes)}:${_formatTwoDigits(_timerService.currentSessionRemaining.inSeconds % 60)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w300, 
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton("Pause", _timerService.pauseTimer),
                    const SizedBox(width: 20),
                    _buildButton(
                      _timerService.isRunning ? "Restart" : "Start", 
                      _timerService.isRunning ? _timerService.resetTimers : _timerService.startTimer,
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard({required String title, required Duration duration, required VoidCallback onTap}) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeBox("HOUR", hours),
                  _buildTimeBox("MINUTE", minutes),
                  _buildTimeBox("SECOND", seconds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: darkBlueColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 100,
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _formatTwoDigits(value),
            style: TextStyle(
              color: darkBlueColor.withOpacity(0.6),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkBlueColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}