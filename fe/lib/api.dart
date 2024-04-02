import 'package:enhanced_http/enhanced_http.dart';
import 'package:flutter/material.dart';
import 'classes/get_ride_class.dart';
import 'dart:async';
import "./classes/get_user_class.dart";
import "./auth_provider.dart";

EnhancedHttp http = EnhancedHttp(baseURL: 'http://localhost:1337');
EnhancedHttp httpGeoapify = EnhancedHttp(baseURL: 'https://api.geoapify.com/v1/routing');
EnhancedHttp httpVES = EnhancedHttp(baseURL: 'https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles');

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
  final response = await http.get('/rides/660b0b6dbc53dd2340ceeda0'); //hardcoded 
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

Future<User> fetchUserByUsername(username) async {
  final response = await http.get('/users?username=${username}');
  if (response.isNotEmpty) {
   var user = User.fromJson(response[0] as Map<String, dynamic>);
      return user;
  } else {
    throw Exception('No users found');
  }
}

Future fetchDistance(waypoints) async {
  final response = await httpGeoapify.get('?waypoints=${waypoints}&mode=drive&apiKey=9ac318b7da314e00b462f8801c758396');
  print(response["features"][0]["properties"]["distance"]);
  return response;
}

Future fetchCarDetails() async {

  //just using co2 and fuel type 
  final respones = await 
  return response
}


// Future<User> fetchImageByUsername(username) async {
//   final response = await http.get('/users/${username}/image');
//   if (response.isNotEmpty) {
//    var _profileImage = Image.memory(response.bodyBytes).image
//    return _profileImage
//   } else {
//     throw Exception('No image found');
//   }
// }






