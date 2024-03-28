class User {
  final String? username;
  final String? password;
  
  const User ({
  this.username,
  this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }
  static List<User> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map<User>((json) => User.fromJson(json)).toList();
  }
}
