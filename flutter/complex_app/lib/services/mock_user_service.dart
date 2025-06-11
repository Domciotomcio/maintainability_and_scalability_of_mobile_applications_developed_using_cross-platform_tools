import '../models/user.dart';

class MockUserService {
  static final List<User> _users = List.generate(
    100,
    (i) => User(
      id: '${i + 1}',
      name: 'User${i + 1}',
      email: 'user${i + 1}@example.com',
    ),
  );

  static List<User> getUsers() => _users;
  static User? getUserById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }
}
