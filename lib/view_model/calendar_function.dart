import 'dart:async';
import 'package:flutter/material.dart';
import '../services/schedule_service.dart';

class CalendarFunction extends ChangeNotifier {
  final ScheduleService _scheduleService = ScheduleService();

  late DateTime currentMonthYear;
  late DateTime selectedDate;

  Map<String, List<ScheduleEvent>> _eventsMap = {};
  StreamSubscription? _schedulesSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, List<ScheduleEvent>> get eventsMap => _eventsMap;

  CalendarFunction() {
    final now = DateTime.now();
    currentMonthYear = DateTime(now.year, now.month, 1);
    selectedDate = DateTime(now.year, now.month, now.day);
    _listenToSchedules();
  }

  void _listenToSchedules() {
    _schedulesSubscription = _scheduleService.schedulesStream().listen((events) {
      _eventsMap = {};
      for (final event in events) {
        if (_eventsMap[event.dateKey] == null) {
          _eventsMap[event.dateKey] = [];
        }
        _eventsMap[event.dateKey]!.add(event);
      }
      notifyListeners();
    });
  }

  List<DateTime> generateDropdownItems() {
    List<DateTime> items = [];
    int currentYear = DateTime.now().year;

    for (int year = currentYear - 1; year <= currentYear + 1; year++) {
      for (int month = 1; month <= 12; month++) {
        items.add(DateTime(year, month, 1));
      }
    }
    return items;
  }

  String getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  List<String> getDaysInMonthList(DateTime date) {
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

  String formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String get selectedDateKey => formatDateKey(selectedDate);

  List<ScheduleEvent> get currentEvents => _eventsMap[selectedDateKey] ?? [];

  bool hasEventsOnDate(DateTime date) {
    String key = formatDateKey(date);
    return _eventsMap.containsKey(key) && _eventsMap[key]!.isNotEmpty;
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setMonthYear(DateTime date) {
    currentMonthYear = date;
    notifyListeners();
  }

  Future<void> addEvent({
    required String title,
    required String note,
    required String time,
  }) async {
    if (title.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _scheduleService.addSchedule(
        dateKey: selectedDateKey,
        title: title,
        note: note,
        time: time,
      );
    } catch (e) {
      debugPrint('Error adding schedule: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEvent({
    required ScheduleEvent event,
    required String title,
    required String note,
    required String time,
  }) async {
    if (title.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _scheduleService.updateSchedule(
        scheduleId: event.id,
        title: title,
        note: note,
        time: time,
      );
    } catch (e) {
      debugPrint('Error updating schedule: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(ScheduleEvent event) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _scheduleService.deleteSchedule(event.id);
    } catch (e) {
      debugPrint('Error deleting schedule: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _schedulesSubscription?.cancel();
    super.dispose();
  }
}
