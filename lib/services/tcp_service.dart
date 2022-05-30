import 'dart:io';

import 'package:client_tcp/base/base_notifier.dart';


mixin TcpService on BaseNotifier{
  Socket? socket;

  Future<bool> connectToSocket(String brokerId, Function(String) handleSocket, Function(dynamic) onError, Function onDone) async{
    try{
      final ipAndPort = brokerId.split(':');
      socket = await Socket.connect(ipAndPort[0], int.parse(ipAndPort[1]));
      socket?.listen(
        (data) => handleSocket(String.fromCharCodes(data).trim()),
        onError: (error) => onError(error),
        onDone: () => onDone(),
        cancelOnError: false
      );
      return true;
    }catch(e){
      showMessage(e.toString(), messageType: MessageTypeEnum.error);
      return false;
    }
  }

  Future<bool> sendOnSocket(TcpCommand command, String value) async{
    try{
      socket?.write('${command.value} $value');
      return true;
    }catch(_){}
    return false;
  }
}


enum TcpCommand{
  subscribe('[SUBSCRIBE]'),
  unsubscribe('[UNSUBSCRIBE]'),
  send('[SEND]'),
  user('[USER]');

  const TcpCommand(this.value);
  final String value;
}