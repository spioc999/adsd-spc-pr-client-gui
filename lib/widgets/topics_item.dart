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
      onTap: topicModel.topicStatus == TopicStatus.subscribing ? null : () => onTap.call(),
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
                  Visibility(
                    visible: topicModel.newMessages == true,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.grey, width: 0.35),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Text(topicModel.topic ?? '', style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis,)),
                  const SizedBox(width: 10,),
                  IconButton(onPressed: topicModel.topicStatus == TopicStatus.unsubscribing ? null : () => onRemove.call(), icon: const Icon(Icons.delete_outline_outlined, color: Colors.red,)),
                  const Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
              Visibility(
                visible: topicModel.topicStatus == TopicStatus.subscribing || topicModel.topicStatus == TopicStatus.unsubscribing,
                child: Text(topicModel.topicStatus.value, style: const TextStyle(fontSize: 8, color: Colors.grey),)
              )
            ],
          ),
        ),
      ),
    );
  }
}