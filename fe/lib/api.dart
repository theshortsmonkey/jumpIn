import 'dart:convert';
import 'package:enhanced_http/enhanced_http.dart';
import 'package:flutter/material.dart';
import 'classes/get_ride_class.dart';
import 'dart:async';
import "./classes/get_user_class.dart";
import "dart:convert";
import "package:http/http.dart" as http;

EnhancedHttp httpEnhanced = EnhancedHttp(baseURL: 'http://localhost:1337');
EnhancedHttp httpGeoapify = EnhancedHttp(baseURL: 'https://api.geoapify.com/v1/routing');
EnhancedHttp httpFuel = EnhancedHttp(baseURL: 'https://www.bp.com');

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
  print('start');
  final response = await httpEnhanced.get('/users/$username');
  print(response);
  if (response.isNotEmpty) {
   var user = User.fromJson(response as Map<String, dynamic>);
      return user;
  } else {
    throw Exception('No users found');
  }
}

Future<User> postUser(user) async {
  String json = jsonEncode(user);
  final response = await http.post(Uri.parse('http://localhost:1337/users'), headers: {"Content-Type": "application/json"},body: json);
  if(response.statusCode == 200) {
   var user = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return user;
  }
  else{
  throw Exception("User not found");
  }
}

Future<User> patchUser(user) async {
  String json = jsonEncode(user);
  String uri = 'http://localhost:1337/users/${user.username}';
  final response = await http.patch(Uri.parse(uri), headers: {"Content-Type": "application/json"},body: json);
  if(response.statusCode == 200) {
  //  var user = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  //   return user;
    List<User> users = jsonDecode(response.body).map<User>((item) {
      return User.fromJson(item as Map<String, dynamic>);
    }).toList();
    return users[0];
  }
  else{
  throw Exception("User not found");
  }
}

// Delete user
Future<User?>deleteUser(user) async {
  final uri = Uri.parse("http://localhost:1337/users/${user.username}");
  final response = await http.delete(uri);

  if(response.statusCode == 200) {
    return null;
  } else {
    throw Exception("Failed to delete user account");
  }
}

Future fetchDistance(waypoints) async {
  final response = await httpGeoapify.get('?waypoints=$waypoints&mode=drive&apiKey=9ac318b7da314e00b462f8801c758396');
  return response;
}

Future fetchFuelPrice(fuelType) async {
  final double fuelPrice;
  final response = await httpFuel.get('/en_gb/united-kingdom/home/fuelprices/fuel_prices_data.json',
    headers: {
      "accept": '*/*',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
    }
  );
  if(fuelType == "PETROL"){
    fuelPrice = response["stations"][0]['prices']['E10']; //petrol price
  } else {
    fuelPrice = response["stations"][0]['prices']['B7']; //diesel price
  }

  print(fuelPrice);
  return fuelPrice;
}

Future fetchCarDetails(carReg) async {
  try {
    final response = await http.post(
      Uri.parse('https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles'),
      headers: {
        'x-api-key': '1gZwZ4vfFN1TbScqIP7FG4ccTa8SkB95aJN9wHBs',
        "accept": '*/*',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD"
      },
      body: jsonEncode({'registrationNumber': carReg}),
    ); 
    print(json.decode(response.body));
    return (json.decode(response.body));
  } catch (e) {
    throw Exception("Error fetching car details: $e");
     // or handle the error accordingly
  }
}








