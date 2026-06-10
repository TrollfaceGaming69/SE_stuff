import 'package:flutter/material.dart';
import '../model/shared_data.dart';

class Todo {
  String text;
  bool isDone;

  Todo({required this.text, this.isDone = false});
}

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

  void _addTodo() {
    setState(() {
      globalTodos.add(Todo(text: ''));
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      globalTodos.removeAt(index);
    });
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
                        child: ListView.builder(
                          itemCount: globalTodos.length,
                          itemBuilder: (context, index) {
                            final todo = globalTodos[index];
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                _deleteTodo(index);
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
                                  setState(() {
                                    todo.isDone = !todo.isDone;
                                  });
                                },
                              ),
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

  const TodoListItem({
    super.key,
    required this.todo,
    required this.taskCardColor,
    required this.darkBlueColor,
    required this.onToggle,
  });

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              onChanged: (value) => widget.todo.text = value,
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