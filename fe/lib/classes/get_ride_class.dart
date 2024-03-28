//define the ride class 
class Ride { //I want to have properties which will have the following types
  final String? id;
  final String? driverUsername;
  final String? to;
  final String? from;
  final List<dynamic>? riderUsernames;
  final int? carbonEmissions;
  final int? distance;
  final int? price;
  final int? driverRating;
  final String? dateTime;
  
  const Ride ({ //this is my Ride class constructor - I am specifying it will have these properties
    this.id,
    this.driverUsername,
    this.to,
    this.from,
    this.riderUsernames,
    this.carbonEmissions,
    this.distance,
    this.price,
    this.driverRating,
    this.dateTime
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride( //access the values on the json object and assign them to the properties I specified in my Ride class constructor
      id: json['id'] as String,
      driverUsername: json['driver_username'] as String,
      to: json['to'] as String,
      from: json['from'] as String,
      riderUsernames: json['rider_usernames'] as List<dynamic>,
      carbonEmissions: json['carbon_emissions'] as int,
      distance: json['distance'] as int,
      price: json['price'] as int,
      driverRating: json['driver_rating'] as int,
      dateTime: json['date_and_time'] as String
    );
  }
  //define the fromJsonList method: it will parse the API response list by applying the factory .fromJson method defined above
  // to assign values to an instance of the Ride class
  //I will use this in my fetchRides() function to parse the response
  static List<Ride> fromJsonList(List<Map<String, dynamic>> jsonList) { 
  return jsonList.map<Ride>((json) => Ride.fromJson(json)).toList(); 
  }
}