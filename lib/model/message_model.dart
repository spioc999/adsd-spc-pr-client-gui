class MessageModel{
  String? topic;
  String? message;
  String? uuid;
  DateTime? timestamp;
  bool? itsMine;
  StatusMessage? statusMessage;
  String? username;

  MessageModel({this.topic, this.message, this.uuid, this.timestamp, this.itsMine = false, this.statusMessage, this.username});

  MessageModel.fromJson(Map<String, dynamic> json)
      : topic = json['topic'],
        message = json['message'],
        uuid = json['uuid'],
        timestamp = DateTime.tryParse(json['timestamp'] ?? ''),
        username = json['username'];

  Map<String, dynamic> toJson() => {
        'message': message,
        'topic': topic,
        'uuid': uuid,
        'timestamp': timestamp?.toIso8601String()
      };
}

enum StatusMessage{
  confirmed,
  pending,
  canceled
}

