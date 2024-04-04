//define the message class
class Chat {
  //I want to have properties which will have the following types
  final String? to;
  final String? from;
  final String? message;

  const Chat(
      {
      //this is my Message class constructor - I am specifying it will have these properties
      this.to,
      this.from,
      this.message
      });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      //access the values on the json object and assign them to the properties I specified in my Message class constructor
      to: json['to'] as String,
      from: json['from'] as String,
      message: json['message'] as String,
    );
  }
  //define the fromJsonList method: it will parse the API response list by applying the factory .fromJson method defined above
  // to assign values to an instance of the Message class
  //I will use this in my fetchMessages() function to parse the response
  static List<Chat> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map<Chat>((json) => Chat.fromJson(json)).toList();
  }
}
