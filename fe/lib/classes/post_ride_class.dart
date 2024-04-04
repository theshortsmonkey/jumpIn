//this is a class for submitting the ridedata 

class PostRideClass {
  final String? to;
  final String? to_region;
  final String? from;
  final String? from_region;
  final String? driver_username;
  final int? available_seats;
  final int? carbon_emissions;
  final int? distance;
  final int? price;
  final map;
  final DateTime? date_and_time; //NB you are using calendar, are you inputting a DateTime? How are you handling that

  PostRideClass({
    this.to,
    this.to_region,
    this.from,
    this.from_region,
    this.driver_username,
    this.available_seats,
    this.carbon_emissions,
    this.distance,
    this.price,
    this.map = null,
    this.date_and_time
  });

  Map<String, dynamic> toJson() => {
        "to" : to,
        "to_region": to_region,
        "from" : from,
        'from_region': from_region,
        "driver_username" : driver_username,
        "available_seats": available_seats,
        "carbon_emissions": carbon_emissions,
        "distance": distance,
        "price": price,
        "map": map,
        "date_and_time": date_and_time?.toIso8601String()
      };
}