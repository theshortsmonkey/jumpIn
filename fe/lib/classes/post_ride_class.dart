//this is a class for submitting the ridedata 

class RideData {
  final String startPoint;
  final String startRegion;
  final String endPoint;
  final String endRegion;
  final DateTime? date; //NB you are using calendar, are you inputting a DateTime? How are you handling that
  final String price; //NB have you converted the input to a string??
  final int? seatsAvailable;

  RideData({
    required this.startPoint,
    required this.startRegion,
    required this.endPoint,
    required this.endRegion,
    required this.date,
    required this.price,
    required this.seatsAvailable
 
  });
}