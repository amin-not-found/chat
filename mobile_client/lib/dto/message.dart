class MessageDTO {
  String content;
  String sender;
  DateTime timeSent;
  bool? sent;
  MessageDTO({
    required this.content,
    required this.sender,
    this.sent,
    required this.timeSent,
  });

  MessageDTO.fromTimeStr({
    required this.content,
    required this.sender,
    this.sent,
    required String time,
  }) : timeSent = DateTime.parse(time).toLocal();
}
