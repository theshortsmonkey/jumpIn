class Ride {
  final String? id;
  final String? driverUsername;
  final String? to;
  final String? from;
  final dynamic riderUsernames;
  final int? carbonEmissions;
  final int? distance;
  final int? price;
  final int? driverRating;
  final String? dateTime;
  
  const Ride ({
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
    return Ride(
      id: json['id'] as String,
      driverUsername: json['driver_username']
    );
  }
  static List<Ride> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map<Ride>((json) => Ride.fromJson(json)).toList();
  }
}