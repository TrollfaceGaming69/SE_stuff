import '../pages/todo.dart';

List<Todo> globalTodos = [
  Todo(text: 'Send prototype to client'),
  Todo(text: 'Setup Calendar UI Design'),
  Todo(text: 'Review mockup design terbaru', isDone: true),
];

final Map<String, List<Map<String, String>>> globalEventsMap = {
  "2026-06-04": [
    {"time": "08:30 — 11:00", "title": "Setup Calendar UI Design", "note": "Selesaikan slicing UI"},
  ],
  "2026-06-17": [
    {"time": "07:00–08:00", "title": "Zoom Meeting with client", "note": "Review mockup design terbaru"},
  ]
};