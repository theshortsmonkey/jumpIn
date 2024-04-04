import 'dart:convert';
import 'dart:html';
import 'package:enhanced_http/enhanced_http.dart';
import 'package:fe/classes/post_ride_class.dart';
import 'package:flutter/material.dart';
import 'classes/get_ride_class.dart';
import 'classes/get_message_class.dart';
import 'dart:async';
import "./classes/get_user_class.dart";
import './classes/get_chat_class.dart';
import "package:http/http.dart" as http;
import 'package:dio/dio.dart' as dio_http;
import 'package:http_parser/http_parser.dart';

EnhancedHttp httpEnhanced = EnhancedHttp(baseURL: 'http://localhost:1337');
EnhancedHttp httpGeoapify = EnhancedHttp(baseURL: 'https://api.geoapify.com/v1/routing');
EnhancedHttp httpGeocode = EnhancedHttp(baseURL: 'https://api.geoapify.com/v1/geocode');
EnhancedHttp httpFuel = EnhancedHttp(baseURL: 'https://www.bp.com');

Future<List<Ride>> fetchRides({
  String? to,
  String? from,
  String? date_and_time,
  int? price,
  int? available_seats,
  int? carbon_emissions
}) async {
  final queryParams = <String, dynamic>{};
    if (to?.isNotEmpty ?? false) {
    queryParams['to'] = to;
    }
    if (from?.isNotEmpty ?? false) {
      queryParams['from'] = from;
    }
    if (date_and_time != null) {
      queryParams['date_and_time'] = date_and_time;
    }
    if (price != null) {
      queryParams['price'] = price;
    }
    if (available_seats != null) {
      queryParams['available_seats'] = available_seats;
    }
    if (carbon_emissions != null) {
      queryParams['carbon_emissions'] = carbon_emissions;
    }


  final url = Uri.http('localhost:1337', '/rides', queryParams);
  print(url);
  final response = await http.get(url);
  if (response.body.isNotEmpty) {
    final responseData = json.decode(response.body);
    List<Ride> rides = responseData.map<Ride>((item) {
      return Ride.fromJson(item as Map<String, dynamic>);
    }).toList();
    return rides;
  } else {
    throw Exception('No rides found');
  }
}

Future<Ride> fetchRideById(rideId) async {
  final response = await httpEnhanced.get('/rides/${rideId}'); 
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
  try{
  final response = await httpEnhanced.get('/users/$username');
   var user = User.fromJson(response as Map<String, dynamic>);
      return user;
  } catch (e) {
    throw Exception('No users found');
  }
}

Future<User> postUser(user) async {
  String json = jsonEncode(user);
  final response = await http.post(Uri.parse('http://localhost:1337/users'),
      headers: {"Content-Type": "application/json"}, body: json);
  if (response.statusCode == 200) {
    var user = User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return user;
  }
  else{
  throw Exception(response.body);
  }
}

Future<User> patchUser(user) async {
  String json = jsonEncode(user);
  String uri = 'http://localhost:1337/users/${user.username}';
  final response = await http.patch(Uri.parse(uri), headers: {"Content-Type": "application/json"},body: json);
  if(response.statusCode == 200) {
    List<User> users = jsonDecode(response.body).map<User>((item) {
      return User.fromJson(item as Map<String, dynamic>);
    }).toList();
    return users[0];
  } else {
    throw Exception("User not found");
  }
}
Future fetchLatLong(city) async {
  final response = await httpGeocode.get('/search?text=$city&lang=en&limit=10&type=city&filter=countrycode:gb&apiKey=9ac318b7da314e00b462f8801c758396');
  final List longLat = response['features'][0]['geometry']['coordinates'];
  return longLat;
}

Future<User?>deleteUser(user) async {
  final uri = Uri.parse("http://localhost:1337/users/${user.username}");
  final response = await http.delete(uri);

  if(response.statusCode == 200) {
    return null;
  } else {
    throw Exception("Failed to delete user account");
  }
}

//upload image for user
Future<String?> uploadUserProfilePic(String username, String filePath) async {
  final response = await http.post(Uri.parse('http://localhost:1337/users/$username/image'), body: jsonEncode({'filePath':filePath}));
  if (response.statusCode == 201) {
    return 'good';
  } else {
    return 'bad';
  }
}

Future deleteRide(rideId) async {
  final url = Uri.parse('http://localhost:1337/rides/${rideId}');
  final response = await http.delete(url);
  if(response.statusCode == 200) {
    return null;
  } else {
    throw Exception("Failed to delete user account");
  }
}

Future fetchDistance(waypoints) async {
  final response = await httpGeoapify.get('?waypoints=$waypoints&mode=drive&apiKey=9ac318b7da314e00b462f8801c758396');
  final distance = response['features'][0]['properties']['distance'];
  return distance;
}

Future fetchFuelPrice(fuelType) async {
  final double fuelPrice;
  final response = await httpFuel.get(
      '/en_gb/united-kingdom/home/fuelprices/fuel_prices_data.json',
      headers: {
        "accept": '*/*',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      });
  if (fuelType == "PETROL") {
    fuelPrice = response["stations"][0]['prices']['E10']; //petrol price
  } else {
    fuelPrice = response["stations"][0]['prices']['B7']; //diesel price
  }
  return fuelPrice;
}

Future fetchCarDetails(carReg) async {
  try {
    final response = await http.post(
      Uri.parse(
          'https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles'),
      headers: {
        'x-api-key': '1gZwZ4vfFN1TbScqIP7FG4ccTa8SkB95aJN9wHBs',
        "accept": '*/*',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD"
      },
      body: jsonEncode({'registrationNumber': carReg}),
    ); 
    return (json.decode(response.body));
  } catch (e) {
    throw Exception("Error fetching car details: $e");
  }
}

Future<Ride> postRide(ride) async {
  String json = jsonEncode(ride);
  final response = await http.post(Uri.parse('http://localhost:1337/rides'), headers: {"Content-Type": "application/json"},body: json);
  if(response.statusCode == 200) {
        print('Im in future');
   var rideResponse = Ride.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  
    return rideResponse;
  }
  else{
  throw Exception("Ride could not be posted");
  }
}

Future<List<Message>> fetchMessagesByUsername(username) async {
  print('start');
  final response = await httpEnhanced.get('/rides/$username/messages');

  if (response.isNotEmpty) {
    List<Message> messages = response.map<Message>((item) {
      return Message.fromJson(item as Map<String, dynamic>);
    }).toList();
    return messages;
  } else {
    throw Exception('No users found');
  }
}

Future<List<Chat>> fetchMessagesByRideId(ride_id, username) async {
  print('start');
  final response = await httpEnhanced.get('/rides/$ride_id/$username/messages');
  if (response.isNotEmpty) {
    List<Chat> chats = response.map<Chat>((item) {
      return Chat.fromJson(item as Map<String, dynamic>);
    }).toList();
    print(chats);
    return chats;
  } else {
    throw Exception('No users found');
  }
}

Future<Message> postMessage(message) async {
  String json = jsonEncode(message);
  final response = await http.post(Uri.parse('http://localhost:1337/rides/${message.id}/messages'),
      headers: {"Content-Type": "application/json"}, body: json);
  if (response.statusCode == 200) {
    var message = Message.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return message;
  } else {
    throw Exception("Ride not found");
  }
}
