import 'dart:convert';

class MessageModel {
  String? messageId;
  String? senderId;
  String? message;
  String? time;
  MessageModel(
      {required this.messageId,
      required this.senderId,
      required this.message,
      required this.time,
      });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map["messageId"];
    senderId = map["senderId"];
    message = map["message"];
    time = map["time"];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "senderId": senderId,
      "message": message,
      "time": time
    };
  }
}
