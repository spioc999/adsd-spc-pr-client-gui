import 'package:client_tcp/base/base_widget.dart';
import 'package:client_tcp/home_notifier.dart';
import 'package:client_tcp/widgets/app_text_form_field.dart';
import 'package:client_tcp/widgets/message_item.dart';
import 'package:client_tcp/widgets/topics_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeNotifier>(
      builder: (_, notifier, __) => BaseWidget(
        isLoading: notifier.isLoading,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4,child: _TopicsWidget(notifier: notifier)),
            Expanded(flex: 10, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _MainWidget(notifier: notifier),
            ))
          ]
        )
      ),
    );
  }
}

class _TopicsWidget extends StatelessWidget {
  final HomeNotifier notifier;
  const _TopicsWidget({Key? key, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        color: Colors.blueGrey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8,),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('TOPICS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: notifier.topics.isEmpty ? 
                          const Padding(padding: EdgeInsets.only(left: 10.0), child: Text('No topics yet.', style: TextStyle(color: Colors.black54),)) :
                          ListView.builder(
                            controller: ScrollController(),
                            itemCount: notifier.topics.length,
                            itemBuilder: (_, index) => TopicsItem(
                              topicModel: notifier.topics[index], 
                              onTap: () => notifier.onTapTopic(index), 
                              onRemove: () => notifier.onRemoveTopic(index), 
                              isSelected: notifier.topics[index].topic == notifier.selectedTopic
                            )
                          )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: notifier.addTopicController,
                      enabled: notifier.isConnected,
                      onChanged: (value) => notifier.onChangeTopicToAdd(value),
                      onFieldSubmitted: notifier.addTopicEnabled ? () => notifier.addTopic() : null,
                      hintText: notifier.isConnected ? 'Enter new topic...' : '',
                    ),
                  ),
                  const SizedBox(width: 5,),
                  InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    onTap: notifier.addTopicEnabled ? () => notifier.addTopic() : null,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: notifier.addTopicEnabled ? Colors.blue : Colors.grey,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20,),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainWidget extends StatelessWidget {
  final HomeNotifier notifier;
  const _MainWidget({Key? key, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if(notifier.isConnected)
                  Flexible(
                        flex: 1,
                        child: AppTextFormField(
                          controller: notifier.usernameController,
                          onChanged: (value) => notifier.onChangeUsername(value),
                          onFieldSubmitted: notifier.sendUsernameEnabled ? () => notifier.sendUsername() : null,
                          labelText: 'Username',
                          suffix: InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                            onTap: notifier.sendUsernameEnabled ? () => notifier.sendUsername() : null,
                            child: Container(
                              width: 22, height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: notifier.sendUsernameEnabled ? Colors.blue : Colors.grey,
                              ),
                              child: const Icon(Icons.person_add_alt, color: Colors.white, size: 14,),
                            ),
                          ),
                        ),
                      ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: !notifier.isConnected ? () => notifier.connect() : null,
                    onDoubleTap: notifier.isConnected ? () => notifier.onDone(clearBroker: true) : null,
                    child: Tooltip(
                      message: notifier.broker != null && notifier.isConnected ? 'Broker: ${notifier.broker}\nDouble click to disconnect' : 'Tap on me to connect!',
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.15),
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: notifier.isConnected ? Colors.green : Colors.red,
                                border: Border.all(color: Colors.grey, width: 0.35),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            const SizedBox(width: 4,),
                            Text('${notifier.isConnected ? '' : 'NOT ' }CONNECTED')
                          ]
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if(!notifier.isConnected && notifier.broker != null) Expanded(child: Center(child: Text('Connection with ${notifier.broker} lost,\n please reconnect and add again topics!', textAlign: TextAlign.center,)))
        else if (!notifier.isConnected) const Expanded(child: Center(child: Text('Please connect first!')))
        else if (notifier.selectedTopic == null) const Expanded(child: Center(child: Text('Select a topic!')))
        else ...[
          Expanded(
            child: notifier.messagesOfSelectedTopic.isEmpty ? 
              const Center(child: Text('No message yet for this topic!')) : ListView.builder(
                controller: notifier.messagesScrollController,
                itemCount: notifier.messagesOfSelectedTopic.length,
                itemBuilder: (_, index) => MessageItem(message: notifier.messagesOfSelectedTopic[index]),
              )           
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: notifier.messageController,
                    onChanged: (value) => notifier.onChangeMessageToSend(value),
                    onFieldSubmitted: notifier.sendMessageEnabled ? () => notifier.sendMessage() : null,
                    hintText: 'Message...',
                  ),
                ),
                const SizedBox(width: 5,),
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  onTap: notifier.sendMessageEnabled ? () => notifier.sendMessage() : null,
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notifier.sendMessageEnabled ? Colors.blue : Colors.grey,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 20,),
                  ),
                )
              ],
            ),
          ),
        ]
      ],
    );
  }
}