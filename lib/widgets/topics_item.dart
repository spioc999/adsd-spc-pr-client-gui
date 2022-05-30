import 'package:client_tcp/model/topic_model.dart';
import 'package:flutter/material.dart';

class TopicsItem extends StatelessWidget {
  final TopicModel topicModel;
  final Function onTap;
  final Function onRemove;
  final bool isSelected;

  const TopicsItem({
    Key? key,
    required this.topicModel,
    required this.onTap,
    required this.onRemove,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: topicModel.topicStatus == TopicStatus.subscribing || topicModel.topicStatus == TopicStatus.unsubscribing ? null : () => onTap.call(),
      child: Container(
        color: isSelected ? Colors.blue.shade300 : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Text(topicModel.topic ?? '', style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis,)),
                  const SizedBox(width: 10,),
                  IconButton(onPressed: () => onRemove.call(), icon: const Icon(Icons.delete_outline_outlined, color: Colors.red,)),
                  const Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
              Visibility(
                visible: topicModel.topicStatus == TopicStatus.subscribing || topicModel.topicStatus == TopicStatus.unsubscribing,
                child: Text(topicModel.topicStatus.value, style: const TextStyle(fontSize: 12, color: Colors.grey),)
              )
            ],
          ),
        ),
      ),
    );
  }
}