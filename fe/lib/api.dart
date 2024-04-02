import 'package:enhanced_http/enhanced_http.dart';
import 'classes/get_ride_class.dart';
import 'dart:async';
import "./classes/get_user_class.dart";
import "dart:convert";
import "package:http/http.dart" as http;

EnhancedHttp httpEnhanced = EnhancedHttp(baseURL: 'http://localhost:1337');
EnhancedHttp httpGeoapify = EnhancedHttp(baseURL: 'https://api.geoapify.com/v1/routing');

Future<List<Ride>> fetchRides() async {
  final response = await httpEnhanced.get('/rides');
  if (response.isNotEmpty) {
    List<Ride> rides = response.map<Ride>((item) {
      return Ride.fromJson(item as Map<String, dynamic>);
    }).toList();
    return rides;
  } else {
    throw Exception('No rides found');
  }
}

Future<Ride> fetchRideById() async {
  final response = await httpEnhanced.get('/rides/660b0b6dbc53dd2340ceeda0'); //hardcoded 
  if (response.isNotEmpty) {
      return Ride.fromJson(response as Map<String, dynamic>);
  } else {
    throw Exception('No ride found');
  }
}

Future<List<User>> fetchUsers() async {
  final response = await httpEnhanced.get('/users');
  if (response.isNotEmpty) {
    List<User> users = response.map<User>((item) {
      return User.fromJson(item as Map<String, dynamic>);
    }).toList();
    return users;
  } else {
    throw Exception('No users found');
  }
}

Future<User> fetchUserByUsername(username) async {
  final response = await httpEnhanced.get('/users/$username');
  if (response.isNotEmpty) {
    print(response);
   var user = User.fromJson(response as Map<String, dynamic>);
      return user;
  } else {
    throw Exception('No users found');
  }
}

Future<User> postUser(user) async {
  String json = jsonEncode(user);
  // print(json);
  final response = await http.post(Uri.parse('http://localhost:1337/users'), headers: {"Content-Type": "application/json"},body: json);
  if(response.statusCode == 200) {
    // print(jsonDecode(response.body));
   var user = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return user;
  }
  else{
  throw Exception("User not found");
  }
}

Future fetchDistance(waypoints) async {
  final response = await httpGeoapify.get('?waypoints=$waypoints&mode=drive&apiKey=9ac318b7da314e00b462f8801c758396');
  return response;
}







