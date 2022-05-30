import 'package:client_tcp/model/message_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  const MessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itsMine = message.itsMine == true;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: itsMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if(message.username?.isNotEmpty == true && !itsMine) Padding(padding: const EdgeInsets.only(left: 42.0),child: Text(message.username ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12),),),
          const SizedBox(height: 4,),
          Row(
            children: [
              if(!itsMine) 
                ...[CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(Random().nextInt(0xffffffff)),
                        child: message.username?.isNotEmpty == true ? Text(message.username?[0].toUpperCase() ?? '') : const Icon(Icons.person),
                      ), 
                      const SizedBox(width: 10,)
                    ],
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: itsMine ? 40 : 0, right: itsMine ? 0 : 40),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: itsMine ? Colors.blue.shade200 : Colors.blueGrey.shade200,
                    ),
                    child: Text(message.message ?? ''),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(message.timestamp?.toIso8601String() ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12),),
              ),
              Visibility(
                visible: message.itsMine == true,
                child: Padding(padding: const EdgeInsets.only(left: 10), child: Icon(_iconStatus, size: 14, color: Colors.grey,),)
              )
            ],
          )
        ],
      ),
    );
  }

  IconData get _iconStatus {
    switch(message.statusMessage){
      case StatusMessage.confirmed:
        return Icons.check;
      case StatusMessage.pending:
        return Icons.timelapse_outlined;
      default:
        return Icons.close;
    }
  }
}