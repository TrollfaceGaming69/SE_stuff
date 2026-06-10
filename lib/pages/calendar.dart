import 'package:flutter/material.dart';
import '../model/shared_data.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime currentMonthYear = DateTime(2026, 6, 1);
  DateTime selectedDate = DateTime(2026, 6, 4);

  List<DateTime> _generateDropdownItems() {
    List<DateTime> items = [];
    for (int year = 2025; year <= 2027; year++) {
      for (int month = 1; month <= 12; month++) {
        items.add(DateTime(year, month, 1));
      }
    }
    return items;
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  List<String> _getDaysInMonthList(DateTime date) {
    List<String> days = [];
    int totalDays = DateUtils.getDaysInMonth(date.year, date.month);
    int firstWeekday = DateTime(date.year, date.month, 1).weekday;
    int blankSpaces = firstWeekday == 7 ? 0 : firstWeekday;

    for (int i = 0; i < blankSpaces; i++) {
      days.add('');
    }
    for (int i = 1; i <= totalDays; i++) {
      days.add(i.toString());
    }
    return days;
  }

  void _showEditEventModal(int index, Map<String, String> event) {
    final titleController = TextEditingController(text: event["title"]);
    final noteController = TextEditingController(text: event["note"] ?? "");
    final timeController = TextEditingController(text: event["time"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF2F0F4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
                  style: const TextStyle(color: Color(0xFF1E2865), fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Title', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2865))),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                  ),
                ),
                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Note', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2865))),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                  ),
                ),
                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2865))),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: timeController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          ),
                          onPressed: () {
                            String dateKey = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                            setState(() {
                              globalEventsMap[dateKey]!.removeAt(index);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000F65),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          ),
                          onPressed: () {
                            if (titleController.text.isNotEmpty) {
                              String dateKey = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                              setState(() {
                                globalEventsMap[dateKey]![index] = {
                                  "time": timeController.text,
                                  "title": titleController.text,
                                  "note": noteController.text,
                                };
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddEventModal() {
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    final timeController = TextEditingController(text: "08:30 — 11.00");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF2F0F4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'add event on',
                  style: TextStyle(color: Colors.black45, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
                  style: const TextStyle(color: Color(0xFF1E2865), fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Title', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2865))),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'agenda title',
                    hintStyle: const TextStyle(color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                  ),
                ),
                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Note', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2865))),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: 'note',
                    hintStyle: const TextStyle(color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                  ),
                ),
                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2865))),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: timeController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000F65),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: () {
                      if (titleController.text.isNotEmpty) {
                        String dateKey = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                        setState(() {
                          if (globalEventsMap[dateKey] == null) {
                            globalEventsMap[dateKey] = [];
                          }
                          globalEventsMap[dateKey]!.add({
                            "time": timeController.text,
                            "title": titleController.text,
                            "note": noteController.text,
                          });
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgTop = Color(0xFF444B9D);
    const Color bgMiddle = Color(0xFF6D439B);
    const Color bgBottom = Color(0xFFD784B4);
    const Color containerColor = Color(0xFFF2F0F4);
    const Color textDarkColor = Color(0xFF1E2865);

    final List<String> daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final List<String> daysInMonth = _getDaysInMonthList(currentMonthYear);

    String selectedDateKey = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    List<Map<String, String>> currentEvents = globalEventsMap[selectedDateKey] ?? [];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgMiddle, bgBottom],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    popupMenuTheme: const PopupMenuThemeData(
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  child: PopupMenuButton<DateTime>(
                    onSelected: (DateTime newValue) {
                      setState(() {
                        currentMonthYear = newValue;
                      });
                    },
                    color: bgMiddle,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    offset: const Offset(0, 40),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, 
                      children: [
                        Text(
                          "${_getMonthName(currentMonthYear.month)} ${currentMonthYear.year}",
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 28),
                      ],
                    ),
                    itemBuilder: (BuildContext context) {
                      return _generateDropdownItems().map((DateTime date) {
                        return PopupMenuItem<DateTime>(
                          value: date,
                          child: Text(
                            "${_getMonthName(date.month)} ${date.year}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: daysOfWeek.map((day) => Expanded(
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textDarkColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1, color: Colors.grey),
                      const SizedBox(height: 12),
                      
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: daysInMonth.length,
                        itemBuilder: (context, index) {
                          String dayText = daysInMonth[index];
                          if (dayText.isEmpty) return const SizedBox.shrink();

                          int dayInt = int.parse(dayText);
                          DateTime cellDate = DateTime(currentMonthYear.year, currentMonthYear.month, dayInt);
                          
                          bool isSelected = selectedDate.year == cellDate.year &&
                                            selectedDate.month == cellDate.month &&
                                            selectedDate.day == cellDate.day;

                          String cellDateKey = "${cellDate.year}-${cellDate.month.toString().padLeft(2, '0')}-${cellDate.day.toString().padLeft(2, '0')}";
                          bool hasEvent = globalEventsMap.containsKey(cellDateKey) && globalEventsMap[cellDateKey]!.isNotEmpty;

                          BoxDecoration boxDecoration = const BoxDecoration();
                          TextStyle textStyle = const TextStyle(color: textDarkColor, fontWeight: FontWeight.w500);

                          if (isSelected) {
                            boxDecoration = const BoxDecoration(
                              color: Color(0xFF5E65A7),
                              shape: BoxShape.circle,
                            );
                            textStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
                          } else if (hasEvent) {
                            boxDecoration = BoxDecoration(
                              border: Border.all(color: textDarkColor.withValues(alpha: 0.5), width: 1),
                              shape: BoxShape.circle,
                            );
                            textStyle = const TextStyle(color: textDarkColor, fontWeight: FontWeight.bold);
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = cellDate;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: boxDecoration,
                              child: Text(dayText, style: textStyle),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Schedule',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.white, size: 32),
                      onPressed: _showAddEventModal,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              currentEvents.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: Text(
                          'No events for this day.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentEvents.length,
                      itemBuilder: (context, index) {
                        final event = currentEvents[index];
                        return GestureDetector(
                          onTap: () => _showEditEventModal(index, event),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event["time"] ?? '',
                                  style: const TextStyle(color: Color(0xFF5E65A7), fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event["title"] ?? '',
                                  style: const TextStyle(color: Color(0xFF1E2865), fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 24),
            ],
            ),
          ),
        ),
      ),
    );
  }
}