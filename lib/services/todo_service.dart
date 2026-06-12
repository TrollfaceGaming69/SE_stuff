import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Todo {
  String id;
  String text;
  bool isDone;
  Timestamp? createdAt;

  Todo({
    this.id = '',
    required this.text,
    this.isDone = false,
    this.createdAt,
  });

  factory Todo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id,
      text: data['text'] ?? '',
      isDone: data['isDone'] ?? false,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isDone': isDone,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _todosCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('todos');
  }

  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;

  Stream<List<Todo>> todosStream() {
    final uid = _currentUid;
    if (uid == null) return Stream.value([]);

    return _todosCollection(uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList());
  }

  Future<String> addTodo(String text) async {
    final uid = _currentUid;
    if (uid == null) throw Exception('User not authenticated');

    final docRef = await _todosCollection(uid).add({
      'text': text,
      'isDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<void> updateTodoText(String todoId, String text) async {
    final uid = _currentUid;
    if (uid == null) return;

    await _todosCollection(uid).doc(todoId).update({'text': text});
  }

  Future<void> toggleTodoDone(String todoId, bool isDone) async {
    final uid = _currentUid;
    if (uid == null) return;

    await _todosCollection(uid).doc(todoId).update({'isDone': isDone});
  }

  Future<void> deleteTodo(String todoId) async {
    final uid = _currentUid;
    if (uid == null) return;

    await _todosCollection(uid).doc(todoId).delete();
  }
}
