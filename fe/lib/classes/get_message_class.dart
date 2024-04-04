//define the message class
class Message {
  //I want to have properties which will have the following types
  final String? id;
  final String? from;
  final String? to;
  final List<dynamic>? chats;

  const Message(
      {
      //this is my Message class constructor - I am specifying it will have these properties
      this.id,
      this.from,
      this.to,
      this.chats});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      //access the values on the json object and assign them to the properties I specified in my Message class constructor
      id: json['_id'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      chats: json['chats'] as List<dynamic>,
    );
  }
  //define the fromJsonList method: it will parse the API response list by applying the factory .fromJson method defined above
  // to assign values to an instance of the Message class
  //I will use this in my fetchMessages() function to parse the response
  static List<Message> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map<Message>((json) => Message.fromJson(json)).toList();
  }
}
