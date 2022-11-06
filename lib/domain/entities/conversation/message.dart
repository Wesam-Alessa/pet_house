class Message {
  Message({
    required this.id,
    this.text,
    required this.createdAt,
    required this.isMe,
  });

  int id;
  String? text;
  String createdAt;
  bool isMe;

  Message copyWith({
  required int id,
  String? text,
  String? type,
  String? attachment,
  String? voice,
  required String createdAt,
  required bool isMe,
  }) => 
    Message(
      id: id,
      text: text,
      isMe: isMe,
      createdAt: createdAt,
    );

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"]??0,
    text: json["text"],
    isMe: json["isMe"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "isMe": isMe,
    "createdAt": createdAt,
  };
}