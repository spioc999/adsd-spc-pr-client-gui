import 'dart:convert';
import 'package:client_tcp/base/base_notifier.dart';
import 'package:client_tcp/model/message_from_socket.dart';
import 'package:client_tcp/model/message_model.dart';
import 'package:client_tcp/model/topic_model.dart';
import 'package:client_tcp/services/rest_service.dart';
import 'package:client_tcp/services/tcp_service.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

//TODO user and not read flag and pallino che cambia sempre colore

class HomeNotifier extends BaseNotifier with RestService, TcpService{
  final List<TopicModel> _topics = [];
  String? _selectedTopic;
  bool isConnected = false;
  String? _topicToAdd;
  String? _messageToSend;
  String? broker;
  final Map<String, List<MessageModel>?> _messages = {};

  TextEditingController addTopicController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  void onTapTopic(int index) {
    _selectedTopic = _topics[index].topic;
    notifyListeners();
  }

  void onRemoveTopic(int index) async{
    if(await sendOnSocket(TcpCommand.unsubscribe, jsonEncode(_topics[index].toJson()))){
      _topics[index].topicStatus = TopicStatus.unsubscribing;
      if(_topics[index].topic == _selectedTopic) _selectedTopic = null;
      notifyListeners();
    }
  }

  void onChangeTopicToAdd(String value){
    _topicToAdd = value;
    notifyListeners();
  }

  void addTopic() async{
    if(_topicToAdd != null) {
      if(topics.map((e) => e.topic).contains(_topicToAdd)){
        showMessage('$_topicToAdd already subscribed!');
      }else{
        final topicModel = TopicModel(topic: _topicToAdd, uuid: getUniqueId(), topicStatus: TopicStatus.subscribing);
        if(await sendOnSocket(TcpCommand.subscribe, jsonEncode(topicModel.toJson()))){
          _topics.add(topicModel);
          _topicToAdd = null;
          addTopicController.clear();
          notifyListeners();
        }
      }
    }
  }

  void connect() async{
    if(!isConnected){
      showLoading();
      final brokerFromService = await getBroker();
      if(brokerFromService != null){
        if(await connectToSocket(brokerFromService, handleMessagesFromSocket, onError, onDone)){
          isConnected = true;
          broker = brokerFromService;
          showMessage('Connected successfully!');
        }
      }
      hideLoading();
    }
  }


  void onChangeMessageToSend(String value){
    _messageToSend = value;
    notifyListeners();
  }

  void sendMessage() async{
    if(_messageToSend != null && selectedTopic != null) {
      final messageModel = MessageModel(
        topic: selectedTopic,
        message: _messageToSend,
        uuid: getUniqueId(),
        timestamp: DateTime.now(),
        statusMessage: StatusMessage.pending,
        itsMine: true
      );
      if(await sendOnSocket(TcpCommand.send, jsonEncode(messageModel.toJson()))){
        addToMessagesSafely(selectedTopic ?? '', messageModel);
        _messageToSend = null;
        messageController.clear();
        notifyListeners();
      }
    }
  }

  void handleMessagesFromSocket(String message){
    try{
      final messageFromSocket = MessageFromSocket.fromJson(jsonDecode(message));
      printInDebug(message);
      switch(messageFromSocket.messageFromSocketType ?? MessageFromSocketType.none){
        case MessageFromSocketType.okSend:
          if(messageFromSocket.uuid != null){
            final messageSameUuid = _allMessages.firstWhereOrNull((m) => m.uuid == messageFromSocket.uuid && m.itsMine == true);
            messageSameUuid?.statusMessage = StatusMessage.confirmed;
          }
          break;
        case MessageFromSocketType.errorSend:
          if(messageFromSocket.uuid != null){
            final messageSameUuid = _allMessages.firstWhereOrNull((m) => m.uuid == messageFromSocket.uuid && m.itsMine == true);
            messageSameUuid?.statusMessage = StatusMessage.canceled;
            showMessage(messageFromSocket.message ?? '', messageType: MessageTypeEnum.error);
          }
          break;
        case MessageFromSocketType.okSubscribe:
          if(messageFromSocket.uuid != null){
            final topicSameUuid = _topics.firstWhereOrNull((t) => t.uuid == messageFromSocket.uuid);
            topicSameUuid?.topicStatus = TopicStatus.confirmed;
          }
          break;
        case MessageFromSocketType.errorSubscribe:
          showMessage(messageFromSocket.message ?? '', messageType: MessageTypeEnum.error);
          break;
        case MessageFromSocketType.okUnsubscribe:
          if(messageFromSocket.uuid != null){
            final topicToRemove = _topics.firstWhereOrNull((t) => t.uuid == messageFromSocket.uuid);
            if(topicToRemove != null){
              _topics.remove(topicToRemove);
              _messages[topicToRemove.topic ?? ''] = null; //TODO lock
            }
          }
          break;
        case MessageFromSocketType.errorUnsubscribe:
          showMessage(messageFromSocket.message ?? '', messageType: MessageTypeEnum.error);
          break;
        case MessageFromSocketType.newMessage:
          addToMessagesSafely(messageFromSocket.topic ?? '', messageFromSocket);
          break;
        case MessageFromSocketType.okUser:
          // TODO: Handle this case.
          break;
        case MessageFromSocketType.errorUser:
          // TODO: Handle this case.
          break;
        default:
          showMessage(messageFromSocket.message ?? '');
          break;
      }
      notifyListeners();
    }catch(e){
      printInDebug("Message: $message\nException: $e");
    }
  }

  void onError(error){
    showMessage(error, messageType: MessageTypeEnum.error);
  }

  void onDone(){
    isConnected = false;
    _topics.clear();
    _messages.clear();
    addTopicController.clear();
    messageController.clear();
    _selectedTopic = null;
    socket?.destroy();
    notifyListeners();
  }

  void addToMessagesSafely(String topic, MessageModel message){
    if(_messages[topic]?.isNotEmpty == true){
      _messages[topic]?.add(message);
    }else{
      _messages[topic] = [message];
    }
  }


  List<MessageModel> get _allMessages => _messages.values.expand<MessageModel>((mess) => mess ?? []).toList();
  List<TopicModel> get topics => _topics;
  String? get selectedTopic => _selectedTopic;
  bool get addTopicEnabled => isConnected && _topicToAdd?.isNotEmpty == true;
  bool get sendMessageEnabled => isConnected && _selectedTopic!= null && _messageToSend?.isNotEmpty == true;
  List<MessageModel> get messagesOfSelectedTopic {
    final filteredMessages = _messages[selectedTopic] ?? [];
    filteredMessages.sort((a,b) => a.timestamp?.compareTo(b.timestamp ?? DateTime.now()) ?? 0);
    return filteredMessages;
  }
}
