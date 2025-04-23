// Model untuk menyimpan data Todo (film)
class Todo {
  int? id; // ID unik dari database (otomatis)
  String title; // Judul film
  String description; // Deskripsi film
  bool isDone; // Apakah film sudah ditonton (checklist)

  // Constructor
  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });

  // Konversi object ke Map (untuk disimpan ke SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0, // SQLite pakai 1/0 untuk boolean
    };
  }

  // Konversi dari Map (hasil baca dari database) ke object Todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      isDone: map['isDone'] == 1,
    );
  }
}
