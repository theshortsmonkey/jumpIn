class RideData {
  final String startPoint;
  final String endPoint;
  final String price;
  final DateTime? date; // Add the date field

  RideData({
    required this.startPoint,
    required this.endPoint,
    required this.price,
    this.date, // Initialize the date
  });
}