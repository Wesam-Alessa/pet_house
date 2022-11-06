import 'package:animal_house/domain/entities/conversation/chat.dart';
import 'package:animal_house/domain/entities/conversation/message.dart';
import 'package:animal_house/domain/entities/user.dart';
import 'package:animal_house/presintaions/common/conversation/chat_widget.dart';
import 'package:animal_house/presintaions/common/text_style.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chats = getChats();
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
                                  chats.indexOf(e) != chats.length - 1
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

List<ChatModel> getChats() {
  return [
    ChatModel(
      id: "1",
      unReadCount: 3,
      lastMessageAt: "2:30 PM",
      user: UserModel(
          id: "1",
          email: "blalb@gmail.com",
          name: 'Olivia',
          picture:
              'https://images.pexels.com/photos/1855582/pexels-photo-1855582.jpeg?auto=compress&cs=tinysrgb&crop=faces&fit=crop&h=200&w=200',
          address: '',
          favourites: [],
          myProducts: [],
          phone: "13246"),
      messages: [
        Message(
          id: 1,
          text: 'Hello',
          isMe: false,
          createdAt: '2:30 PM',
        ),
        Message(
          id: 2,
          text: 'Hey, How are you?',
          isMe: true,
          createdAt: '2:31 PM',
        ),
        Message(
          id: 3,
          text: 'I am fine',
          isMe: false,
          createdAt: '2:32 PM',
        ),
        Message(
          id: 4,
          text: 'And you?',
          isMe: false,
          createdAt: '2:33 PM',
        ),
        Message(
          id: 5,
          text: 'I am fine too',
          isMe: true,
          createdAt: '2:34 PM',
        ),
        Message(
          id: 6,
          text: 'Did you finished the task?',
          isMe: true,
          createdAt: '2:35 PM',
        ),
        Message(
          id: 7,
          text: 'ahh, I finished it',
          isMe: false,
          createdAt: '2:36 PM',
        ),
        Message(
          id: 8,
          text: 'no, I am still working on it',
          isMe: false,
          createdAt: '2:37 PM',
        ),
        Message(
          id: 9,
          text: 'maybe you can help me 🥹',
          isMe: false,
          createdAt: '2:38 PM',
        ),
      ],
    ),
    ChatModel(
      id: "2",
      unReadCount: 1,
      lastMessageAt: "10:30 PM",
      user: UserModel(
          id: "2",
          email: "blalb@gmail.com",
          name: 'Emma',
          picture:
              'https://images.pexels.com/photos/1758845/pexels-photo-1758845.jpeg?auto=compress&cs=tinysrgb&crop=faces&fit=crop&h=200&w=200',
          address: '',
          favourites: [],
          myProducts: [],
          phone: "13246"),
      messages: [
        Message(
          id: 1,
          text: 'Hello',
          isMe: false,
          createdAt: '2:30 PM',
        ),
        Message(
          id: 2,
          text: 'How are you?',
          isMe: true,
          createdAt: '2:31 PM',
        ),
        Message(
          id: 3,
          text: 'I am fine',
          isMe: false,
          createdAt: '2:32 PM',
        ),
      ],
    ),
    ChatModel(
      id: "3",
      unReadCount: 0,
      lastMessageAt: "05:30 AM",
      user: UserModel(
          id: "2",
          email: "blalb@gmail.com",
          name: 'Alex',
          picture:
              'https://images.unsplash.com/photo-1503593245033-a040be3f3c82?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=ca8c652b62b1f14c9c4c969289a8b33c',
          address: '',
          favourites: [],
          myProducts: [],
          phone: "13246"),
      messages: [
        Message(
          id: 1,
          text: 'Hello',
          isMe: false,
          createdAt: '2:30 PM',
        ),
        Message(
          id: 2,
          text: 'How are you?',
          isMe: true,
          createdAt: '2:31 PM',
        ),
        Message(
          id: 3,
          text: 'great',
          isMe: false,
          createdAt: '2:32 PM',
        ),
      ],
    ),
    ChatModel(
      id: "4",
      unReadCount: 0,
      lastMessageAt: "03:30 PM",
      user: UserModel(
          id: "2",
          email: "blalb@gmail.com",
          name: 'Amelia',
          picture:
              'https://images.unsplash.com/photo-1502033303885-c6e0280a4f5c?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=9be99762d86ae47ab59690f72d984be6',
          address: '',
          favourites: [],
          myProducts: [],
          phone: "13246"),
      messages: [
        Message(
          id: 1,
          text: 'Hello',
          isMe: false,
          createdAt: '2:30 PM',
        ),
        Message(
          id: 2,
          text: 'How are you?',
          isMe: true,
          createdAt: '2:31 PM',
        ),
        Message(
          id: 3,
          text: 'ok, cool 😀',
          isMe: false,
          createdAt: '2:32 PM',
        ),
      ],
    ),
    ChatModel(
      id: "5",
      unReadCount: 0,
      lastMessageAt: "00:30 AM",
      user: UserModel(
          id: "2",
          email: "blalb@gmail.com",
          name: 'Ericson',
          picture: 'https://randomuser.me/api/portraits/men/16.jpg',
          address: '',
          favourites: [],
          myProducts: [],
          phone: "13246"),
      messages: [
        Message(
          id: 1,
          text: 'Hello',
          isMe: false,
          createdAt: '2:30 PM',
        ),
        Message(
          id: 2,
          text: 'How are you?',
          isMe: true,
          createdAt: '2:31 PM',
        ),
        Message(
          id: 3,
          text: 'bro, did you take the test?',
          isMe: false,
          createdAt: '2:32 PM',
        ),
      ],
    ),
    ChatModel(
      id: "6",
      unReadCount: 0,
      lastMessageAt: "00:30 AM",
      user: UserModel(
          id: "2",
          email: "blalb@gmail.com",
          name: 'Izaak',
          picture:
              'https://images.unsplash.com/photo-1505503693641-1926193e8d57?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=3422df4a46d2c81c35bf4687a2fa9c52',
          address: '',
          favourites: [],
          myProducts: [],
          phone: "13246"),
      messages: [
        Message(
          id: 1,
          text: 'Hello',
          isMe: false,
          createdAt: '2:30 PM',
        ),
        Message(
          id: 2,
          text: 'How are you?',
          isMe: true,
          createdAt: '2:31 PM',
        ),
        Message(
          id: 3,
          text: 'bro, did you take the test?',
          isMe: false,
          createdAt: '2:32 PM',
        ),
      ],
    ),
    ChatModel(
      id: "7",
      unReadCount: 0,
      lastMessageAt: "01:30 AM",
      user: UserModel(
          id: "2",
          email: "blalb@gmail.com",
          name: 'Sophia',
          picture:
              'https://images.pexels.com/photos/590415/pexels-photo-590415.jpeg?h=350&auto=compress&cs=tinysrgb',
          address: '',
          favourites: [],
          myProducts: [],
          phone: "13246"),
      messages: [
        Message(
          id: 1,
          text: 'Hello',
          isMe: false,
          createdAt: '2:30 PM',
        ),
        Message(
          id: 2,
          text: 'How are you?',
          isMe: true,
          createdAt: '2:31 PM',
        ),
        Message(
          id: 3,
          text: '❤️',
          isMe: false,
          createdAt: '2:32 PM',
        ),
      ],
    ),
    ChatModel(
      id: "8",
      unReadCount: 0,
      lastMessageAt: "yesterday",
      user: UserModel(
          id: "2",
          email: "blalb@gmail.com",
          name: 'Mia',
          picture: 'https://api.uifaces.co/our-content/donated/AVQ0V28X.jpg',
          address: '',
          favourites: [],
          myProducts: [],
          phone: "13246"),
      messages: [
        Message(
          id: 1,
          text: 'Hello',
          isMe: false,
          createdAt: '2:30 PM',
        ),
        Message(
          id: 2,
          text: 'How are you?',
          isMe: true,
          createdAt: '2:31 PM',
        ),
        Message(
          id: 3,
          text: 'I am really happy to see you 😀',
          isMe: false,
          createdAt: '2:32 PM',
        ),
      ],
    ),
    ChatModel(
      id: "9",
      unReadCount: 0,
      lastMessageAt: "yesterday",
      user: UserModel(
          id: "2",
          email: "blalb@gmail.com",
          name: 'Ava',
          picture:
              'https://images.pexels.com/photos/247206/pexels-photo-247206.jpeg?auto=compress&cs=tinysrgb&crop=faces&fit=crop&h=200&w=200',
          address: '',
          favourites: [],
          myProducts: [],
          phone: "13246"),
      messages: [
        Message(
          id: 1,
          text: 'Hello',
          isMe: false,
          createdAt: '2:30 PM',
        ),
        Message(
          id: 2,
          text: 'How are you?',
          isMe: true,
          createdAt: '2:31 PM',
        ),
        Message(
          id: 3,
          text: 'I am really happy to see you 😀',
          isMe: false,
          createdAt: '2:32 PM',
        ),
      ],
    ),
  ];
}
