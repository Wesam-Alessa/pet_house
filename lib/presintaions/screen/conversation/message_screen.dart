import 'dart:developer';

import 'package:animal_house/core/constant/color_constant.dart';
import 'package:animal_house/domain/entities/conversation/chat.dart';
import 'package:animal_house/domain/entities/conversation/message.dart';
import 'package:animal_house/presintaions/common/conversation/message_widget.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with AnimationMixin {
  late ChatModel chat;
  final textController = TextEditingController();
  final _scrollController = ScrollController();

  late Animation<double> opacity;
  late AnimationController slideInputController;
  late Animation<Offset> slideInputAnimation;

  bool isVisible = false;

  @override
  void initState() {
    slideInputController = createController()
      ..duration = const Duration(milliseconds: 500);
    slideInputAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-2, 0),
    ).animate(slideInputController);

    opacity = Tween<double>(begin: 1, end: 0).animate(controller);
    controller.duration = const Duration(milliseconds: 200);

    super.initState();
  }

  addToMessages(String text) {
    ChatModel myModel = chat;
    myModel.messages.insert(
        0,
        Message(
          id: Provider.of<UserProvider>(context, listen: false).getUserModel.id,
          text: text,
          createdAt: DateTime.now().toString(),
          isMe: true,
        ));
    myModel.lastMessageAt = chat.messages[0].createdAt;
    log("CHAT 01:= ${chat.messages[0].id.toString()}");
    log("myModel 01:= ${myModel.messages[0].id.toString()}");

    Provider.of<UserProvider>(context, listen: false)
        .addMessage(myModel: myModel);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    chat = ModalRoute.of(context)!.settings.arguments as ChatModel;
    return Scaffold(
      backgroundColor: ColorConstants.lightBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: ListTile(
          onTap: () {},
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              chat.user.picture,
            ),
          ),
          title: Text(chat.user.name, style: theme.textTheme.headline6),
        ),
      ),
      // a message list
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(Provider.of<UserProvider>(context, listen: false)
                  .getUserModel
                  .id)
              .collection('chats')
              .doc(chat.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.data() != null) {
                log("DATA := ${snapshot.data!.data()!.toString()}");
                chat = ChatModel.fromJson(snapshot.data!.data()!, chat.user);
              }
              return Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: chat.messages.isNotEmpty
                            ? ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                controller: _scrollController,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                itemCount: chat.messages.length,
                                itemBuilder: (context, index) {
                                  return MessageWidget(
                                    message: chat.messages[index],
                                  );
                                },
                              )
                            : Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat,
                                        size: 80,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'No messages yet',
                                        style: theme.textTheme.bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 8,
                                left: 8,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom > 0
                                        ? 15
                                        : 28,
                                top: 8),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: SlideTransition(
                                        position: slideInputAnimation,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: TextField(
                                                  controller: textController,
                                                  minLines: 1,
                                                  maxLines: 5,
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            right: 16,
                                                            left: 20,
                                                            bottom: 10,
                                                            top: 10),
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors
                                                            .grey.shade700),
                                                    hintText: 'Type a message',
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade100,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      gapPadding: 0,
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade200),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      gapPadding: 0,
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      splashRadius: 20,
                                      icon: const Icon(Icons.send,
                                          color: Colors.blue),
                                      onPressed: () {
                                        if (textController.text.isNotEmpty) {
                                          addToMessages(textController.text);
                                          textController.clear();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
