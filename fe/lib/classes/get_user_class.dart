class User {
  final String? id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? bio;
  final bool identity_verification_status;
  final bool? driver_verification_status;
  final dynamic car;
  
  const User ({
  this.id,
  this.username = "",
  this.firstName,
  this.lastName,
  this.email,
  this.phoneNumber,
  this.bio,
  this.identity_verification_status = false,
  this.driver_verification_status,
  this.car
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      bio: json['bio'] as String,
      identity_verification_status: json['identity_verification_status'] as bool,
      driver_verification_status: json['identity_verification_status'] as bool,
      car: json['car'] as dynamic,
    );
  }
  static List<User> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map<User>((json) => User.fromJson(json)).toList();
  }
}
