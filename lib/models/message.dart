class Message {
  final String message_Ident;
  final String to;
  final String from;
  final String message;
  final String time;

//constructor
  Message({
    required this.message_Ident,
    required this.to,
    required this.from,
    required this.message,
    required this.time,
  });

  factory Message.fromMap(String id, Map<String, dynamic> data) {
    return Message(
      message_Ident: id,
      to: data['to'],
      from: data['from'],
      message: data['message'],
      time: data['time'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message_ID': message_Ident,
        'to': to,
        'from': from,
        'message': message,
        'time': time,
      };
}
