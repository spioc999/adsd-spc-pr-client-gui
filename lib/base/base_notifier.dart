import 'package:client_tcp/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BaseNotifier extends ChangeNotifier{
  bool isLoading = false;
  bool _isDisposed = false;

  showLoading(){
    isLoading = true;
    notifyListeners();
  }

  hideLoading(){
    isLoading = false;
    notifyListeners();
  }

  showMessage(String message, {MessageTypeEnum messageType = MessageTypeEnum.info, int durationSec = 2, bool isBold = false}) {
    Color color;
    switch(messageType){

      case MessageTypeEnum.info:
        color = Colors.grey.shade100;
        break;
      case MessageTypeEnum.error:
        color = Colors.red.shade300;
        break;
    }
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: isBold ? Text(message, maxLines: 4,) : Text(message, maxLines: 4, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
        backgroundColor: color,
        duration: Duration(seconds: durationSec),
      )
    );
  }

  String getUniqueId(){
    return const Uuid().v4().replaceAll('-', '');
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if(!_isDisposed){
      super.notifyListeners();
    }
  }

  void printInDebug(object) {
    if(kDebugMode) print(object);
  }

  @protected bool get isDisposed => _isDisposed;
}

enum MessageTypeEnum{
  info,
  error,
}