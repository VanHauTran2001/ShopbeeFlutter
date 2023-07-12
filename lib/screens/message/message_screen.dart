import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saleshoppingapp/constant/color.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:saleshoppingapp/models/message_model.dart';
import 'package:saleshoppingapp/models/user.dart';
import 'package:uuid/uuid.dart';


class MessageScreen extends StatefulWidget {
  final Users users;

  MessageScreen({required this.users});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var uuid = const Uuid();
  TextEditingController messageController = TextEditingController();
  MessageModel? messages;
  void sendMessage() async{
    String msg = messageController.text.toString().trim();
    messageController.clear();
    if(msg != ""){
      MessageModel messageModel = MessageModel(
          messageId: widget.users.idUser,
          senderId: FirebaseAuth.instance.currentUser!.uid,
          message: msg,
          time: DateTime.now().toString()
      );
       FirebaseFirestore.instance.collection("chat").doc(uuid.v1()).set(messageModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorInstance.backgroundColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.users.avatar!),
            ),
            const SizedBox(width: 10),
            Text(
              widget.users.name,
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
        elevation: 5,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    child: StreamBuilder(
                      stream:  FirebaseFirestore.instance.collection("chat").orderBy("time").snapshots(),
                      builder: (context,snapshot){
                        if (snapshot.connectionState == ConnectionState.active) {
                          if(snapshot.hasData){
                            var dataSnapshot = snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                            List<MessageModel> messageList = [];
                            for(var chats in dataSnapshot.docs){
                              messages = MessageModel.fromMap(chats.data());
                              if(messages!.senderId == FirebaseAuth.instance.currentUser!.uid && messages!.messageId == widget.users.idUser
                              || messages!.messageId == FirebaseAuth.instance.currentUser!.uid && messages!.senderId == widget.users.idUser){
                                messageList.add(messages!);
                              }
                            }
                            return ListView.builder(
                                reverse: true,
                                itemCount: messageList.length,
                                shrinkWrap: true,
                                itemBuilder: (context,index){
                                  final messageModel = List.from(messageList.reversed)[index];
                                  return Row(
                                    mainAxisAlignment: (messageModel.senderId == FirebaseAuth.instance.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (messageModel.senderId == FirebaseAuth.instance.currentUser!.uid) ? ColorInstance.backgroundColor : const Color(0xFFE6E6E6),
                                          borderRadius: (messageModel.senderId == FirebaseAuth.instance.currentUser!.uid) ? const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))
                                              : const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                        ),
                                        child: (messageModel.senderId == FirebaseAuth.instance.currentUser!.uid) ? Text(messageModel.message.toString(),style: const TextStyle(color: Colors.white))
                                        : Text(messageModel.message.toString(),style: const TextStyle(color: Colors.black))
                                      )
                                    ],
                                  );
                                }
                            );
                          }else{
                            return Center(
                              child: Text(
                                getString(context, 'message_chat_error'),
                                style: TextStyle(
                                    color: ColorInstance.backgroundColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                        }
                        return Center(
                          child: CircularProgressIndicator(
                              color: ColorInstance.backgroundColor),
                        );
                      },
                    ),
                  ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                child: Row(
                  children: [
                   Flexible(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: getString(context, 'txt_enter_message'),
                          ),
                        )
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                        onPressed: (){
                          sendMessage();
                        },
                        icon: Icon(Icons.send,color: ColorInstance.backgroundColor,size: 35)
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
