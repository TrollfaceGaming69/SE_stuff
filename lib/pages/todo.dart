import 'dart:async';
import 'package:flutter/material.dart';
import '../services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final Color bgTopColor = const Color(0xFF5A53A0);
  final Color bgBottomColor = const Color(0xFFD688AB);
  final Color cardColor = const Color(0xFFF2F2F6);
  final Color taskCardColor = const Color(0xFFBCC0DC);
  final Color darkBlueColor = const Color(0xFF030A59);

  final TodoService _todoService = TodoService();

  void _addTodo() async {
    await _todoService.addTodo('');
  }

  void _deleteTodo(String todoId) async {
    await _todoService.deleteTodo(todoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTopColor, bgBottomColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 30.0, top: 30.0, bottom: 20.0),
                child: Text(
                  'To Do list',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<List<Todo>>(
                          stream: _todoService.todosStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF5A53A0),
                                ),
                              );
                            }

                            final todos = snapshot.data ?? [];

                            if (todos.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 64,
                                      color: darkBlueColor.withOpacity(0.3),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No tasks yet',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: darkBlueColor.withOpacity(0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap the button below to add one',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: darkBlueColor.withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                final todo = todos[index];
                                return Dismissible(
                                  key: ValueKey(todo.id),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    _deleteTodo(todo.id);
                                  },
                                  background: Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    child: const Icon(Icons.delete, color: Colors.white),
                                  ),
                                  child: TodoListItem(
                                    todo: todo,
                                    taskCardColor: taskCardColor,
                                    darkBlueColor: darkBlueColor,
                                    onToggle: () {
                                      _todoService.toggleTodoDone(todo.id, !todo.isDone);
                                    },
                                    onTextChanged: (value) {
                                      _todoService.updateTodoText(todo.id, value);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: _addTodo,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: darkBlueColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 20),
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Add to do',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoListItem extends StatefulWidget {
  final Todo todo;
  final Color taskCardColor;
  final Color darkBlueColor;
  final VoidCallback onToggle;
  final ValueChanged<String> onTextChanged;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.taskCardColor,
    required this.darkBlueColor,
    required this.onToggle,
    required this.onTextChanged,
  });

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.text);
  }

  @override
  void didUpdateWidget(covariant TodoListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todo.text != oldWidget.todo.text &&
        widget.todo.text != _controller.text) {
      _controller.text = widget.todo.text;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onTextChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.taskCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: widget.todo.isDone
                  ? Icon(Icons.check, size: 18, color: widget.darkBlueColor)
                  : null,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: TextFormField(
              controller: _controller,
              onChanged: _onChanged,
              style: TextStyle(
                color: widget.darkBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: widget.todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Task name',
              ),
            ),
          ),
        ],
      ),
    );
  }
}