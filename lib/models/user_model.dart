class UserModel {
  final String id;
  final String name;
  final String email;
  final dynamic age;
  final String batch;
  final String university;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    required this.batch,
    required this.university,
    required this.role,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: (data['name'] ?? '') as String,
      email: (data['email'] ?? '') as String,
      age: data['age'],
      batch: (data['batch'] ?? '') as String,
      university: (data['university'] ?? '') as String,
      role: (data['role'] ?? 'student') as String,
    );
  }
}
