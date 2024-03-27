import 'package:enhanced_http/enhanced_http.dart';
import 'package:flutter/material.dart';
import 'classes/get_ride_class.dart';
import 'dart:async';

EnhancedHttp http = EnhancedHttp(baseURL: 'http://localhost:1337');

Future<List<Ride>> fetchRides() async {
  final response = await http.get('/rides');
  if (response.isNotEmpty) {
    List<Ride> rides = response.map<Ride>((item) {
      // Ensure each item is correctly interpreted as Map<String, dynamic>
      return Ride.fromJson(item as Map<String, dynamic>);
    }).toList();
    return rides;
  } else {
    throw Exception('No rides found');
  }
}







