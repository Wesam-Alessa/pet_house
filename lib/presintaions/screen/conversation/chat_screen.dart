
import 'package:animal_house/presintaions/widgets/conversation/chat_widget.dart';
import 'package:animal_house/presintaions/widgets/text_style.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Your Chat",
          style: TextStyles.titleTextStyle.copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Chats",
                style: theme.textTheme.subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Consumer<UserProvider>(builder: (context, provider, _) {
              return provider.chats.isNotEmpty
                  ? Column(
                      children: provider.chats
                          .map((e) => Column(
                                children: [
                                  ChatWidget(chat: e),
                                  provider.chats.indexOf(e) != provider.chats.length - 1
                                      ? const Divider(
                                          indent: 80,
                                          height: 1,
                                          endIndent: 16,
                                        )
                                      : const SizedBox(),
                                ],
                              ))
                          .toList(),
                    )
                  : provider.chats.isEmpty && provider.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : provider.chats.isEmpty && provider.loading == false
                          ? Center(
                              child: Text(
                                "No Items ",
                                style: TextStyles.cardSubTitleTextStyle2
                                    .copyWith(color: Colors.black),
                              ),
                            )
                          : Container();
            }),
          ],
        ),
      ),
    );
  }
}
