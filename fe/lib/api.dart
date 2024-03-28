import 'package:enhanced_http/enhanced_http.dart';
import 'classes/get_ride_class.dart';
import 'dart:async';
import "./classes/get_user_class.dart";

EnhancedHttp http = EnhancedHttp(baseURL: 'http://localhost:1337');

//
Future<List<Ride>> fetchRides() async {
  final response = await http.get('/rides');
  if (response.isNotEmpty) {
    List<Ride> rides = response.map<Ride>((item) {
      // Ensure each item is correctly interpreted as Map<String, dynamic> 
      // NB Map = object, so Map<String, dynamic> means object key-value pairs of form {string(s): any-value-type}
      return Ride.fromJson(item as Map<String, dynamic>);
    }).toList();
    return rides;
  } else {
    throw Exception('No rides found');
  }
}

Future<Ride> fetchRideById() async {
  final response = await http.get('/rides/6604245dad2e07545e064e81'); //hardcoded 
  if (response.isNotEmpty) {
    print(response);
      // Ensure each item is correctly interpreted as Map<String, dynamic> 
      // NB Map = object, so Map<String, dynamic> means object key-value pairs of form {string(s): any-value-type}
      return Ride.fromJson(response as Map<String, dynamic>);
  } else {
    throw Exception('No ride found');
  }
}

Future<List<User>> fetchUsers() async {
  final response = await http.get('/users');
  if (response.isNotEmpty) {
    List<User> users = response.map<User>((item) {
      return User.fromJson(item as Map<String, dynamic>);
    }).toList();
    return users;
  } else {
    throw Exception('No users found');
  }
}






