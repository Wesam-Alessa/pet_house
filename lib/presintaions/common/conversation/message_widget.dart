import 'package:animal_house/domain/entities/conversation/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (message.isMe) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(right: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xff1972F5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message.text!,
                    style: theme.textTheme.bodyText2
                        ?.copyWith(color: Colors.white)),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    DateFormat('MMM d, h:mm a')
                        .format(DateTime.parse(message.createdAt)),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade300)),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(left: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 225, 231, 236),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.text!, style: theme.textTheme.bodyText2),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    DateFormat('MMM d, h:mm a')
                        .format(DateTime.parse(message.createdAt)),
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      );
    }
  }
}
