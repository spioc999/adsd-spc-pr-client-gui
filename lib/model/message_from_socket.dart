import 'package:client_tcp/model/message_model.dart';
import 'package:flutter/material.dart';

class MessageFromSocket extends MessageModel{
  MessageFromSocketType? messageFromSocketType;

  MessageFromSocket({String? topic, String? message, String? uuid, DateTime? timestamp, this.messageFromSocketType = MessageFromSocketType.none, Color? colorUser})
                  : super(topic: topic, message: message, uuid: uuid, timestamp: timestamp, colorUser: colorUser);

  MessageFromSocket.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    messageFromSocketType = MessageFromSocketType.values.firstWhere((type) => type.value == json['type'], orElse: () => MessageFromSocketType.none);
  }
}


enum MessageFromSocketType{
  okSend('OK_SEND'),
  errorSend('ERROR_SEND'),
  okSubscribe('OK_SUBSCRIBE'),
  errorSubscribe('ERROR_SUBSCRIBE'),
  okUnsubscribe('OK_UNSUBSCRIBE'),
  newMessage('NEW_MESSAGE'),
  errorUnsubscribe('ERROR_UNSUBSCRIBE'),
  okUser('OK_USER'),
  errorUser('ERROR_USER'),
  none('NONE');


  const MessageFromSocketType(this.value);
  final String value;
}


