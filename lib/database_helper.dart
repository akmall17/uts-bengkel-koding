// Helper untuk mengatur database SQLite

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init(); // Singleton
  static Database? _database;

  DatabaseHelper._init();

  // Getter untuk mendapatkan database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(
      'todos.db',
    ); // Init database dengan upgrade support
    return _database!;
  }

  // Inisialisasi database dengan support upgrade
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // Path folder database
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Naikkan versi database
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Tambah kolom description jika upgrade dari versi lama
          await db.execute("ALTER TABLE todos ADD COLUMN description TEXT");
        }
      },
    );
  }

  // Membuat tabel database saat baru pertama kali
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,           -- Tambahan deskripsi
        isDone INTEGER NOT NULL
      )
    ''');
  }

  // Tambah data baru
  Future<int> insertTodo(Todo todo) async {
    final db = await instance.database;
    return await db.insert('todos', todo.toMap());
  }

  // Ambil semua data
  Future<List<Todo>> getTodos() async {
    final db = await instance.database;
    final result = await db.query('todos');
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  // Update data
  Future<int> updateTodo(Todo todo) async {
    final db = await instance.database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // Hapus data berdasarkan ID
  Future<int> deleteTodo(int id) async {
    final db = await instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  // Hapus semua data yang sudah dichecklist (isDone = true)
  Future<int> deleteCompleted() async {
    final db = await instance.database;
    return await db.delete('todos', where: 'isDone = ?', whereArgs: [1]);
  }
}
