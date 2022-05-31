class TopicModel{
  String? topic;
  String? uuid;
  TopicStatus topicStatus;
  bool? newMessages;

  TopicModel({this.topic, this.uuid, this.topicStatus = TopicStatus.none, this.newMessages = false});

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'uuid': uuid
      };
}


enum TopicStatus{
  subscribing('Subscribing...'),
  confirmed(''),
  unsubscribing('Unsubscribing...'),
  none('');

  const TopicStatus(this.value);
  final String value;
}