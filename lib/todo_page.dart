import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> todos = [];
  String searchQuery = ''; // 👉 Menyimpan kata kunci pencarian

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  // 👉 Ambil data dari database dan filter berdasarkan pencarian
  Future<void> loadTodos() async {
    final data = await DatabaseHelper.instance.getTodos();
    setState(() {
      todos =
          data
              .where(
                (todo) => todo.title.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  // 👉 Dialog untuk menambah film baru
  void addTodoDialog() {
    String title = '';
    String description = '';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Tambah Film"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (val) => title = val,
                  decoration: const InputDecoration(labelText: "Nama Film"),
                ),
                TextField(
                  onChanged: (val) => description = val,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi Film",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (title.isNotEmpty && description.isNotEmpty) {
                    await DatabaseHelper.instance.insertTodo(
                      Todo(
                        title: title,
                        description: description,
                        isDone: false,
                      ),
                    );
                    loadTodos();
                    Navigator.pop(context);
                  }
                },
                child: const Text("Tambah"),
              ),
            ],
          ),
    );
  }

  // 👉 Dialog untuk mengedit film
  void updateTodoDialog(Todo todo) {
    String title = todo.title;
    String description = todo.description;
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Update Film"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  onChanged: (val) => title = val,
                  decoration: const InputDecoration(labelText: "Nama Film"),
                ),
                TextField(
                  controller: descriptionController,
                  onChanged: (val) => description = val,
                  decoration: const InputDecoration(
                    labelText: "Deskripsi Film",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (title.isNotEmpty && description.isNotEmpty) {
                    await DatabaseHelper.instance.updateTodo(
                      Todo(
                        id: todo.id,
                        title: title,
                        description: description,
                        isDone: todo.isDone,
                      ),
                    );
                    loadTodos();
                    Navigator.pop(context);
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  // 👉 Ganti status checklist
  void toggleTodo(Todo todo) async {
    await DatabaseHelper.instance.updateTodo(
      Todo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isDone: !todo.isDone,
      ),
    );
    loadTodos();
  }

  // 👉 Hapus film dari database berdasarkan id
  void deleteTodo(int id) async {
    await DatabaseHelper.instance.deleteTodo(id);
    loadTodos();
  }

  // 👉 Hapus semua film yang sudah diceklis (isDone = true)
  void deleteCompletedTodos() async {
    final completedTodos = todos.where((todo) => todo.isDone).toList();

    for (var todo in completedTodos) {
      await DatabaseHelper.instance.deleteTodo(todo.id!);
    }

    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aplikasi List Film Keren"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 👉 Kolom pencarian film
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cari Film...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchQuery = value;
                loadTodos(); // Refresh daftar saat mencari
              },
            ),
          ),
          // 👉 Daftar film ditampilkan di sini
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(todo.description),
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) => toggleTodo(todo),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => updateTodoDialog(todo),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteTodo(todo.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // 👉 Tombol untuk menghapus semua yang sudah diceklis
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: deleteCompletedTodos,
              icon: const Icon(Icons.delete_forever),
              label: const Text("Hapus yang Selesai"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
