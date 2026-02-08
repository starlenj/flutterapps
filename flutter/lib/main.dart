import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter To-Do App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<String> _todos = [];
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    setState(() {
      _todos.add(_controller.text);
      _controller.clear();
    });
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Column(
        children: <Widget>[ 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Add a new task')), 
          ),
          ElevatedButton(onPressed: _addTodo, child: const Text('Add')), 
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(index.toString()),
                  onDismissed: (direction) {
                    _removeTodo(index);
                  },
                  child: ListTile(title: Text(_todos[index])), 
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
