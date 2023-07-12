import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saleshoppingapp/firebase_helper/firestore_database/firebase_firestore.dart';
import 'package:saleshoppingapp/models/user.dart';
import 'package:saleshoppingapp/screens/message/message_screen.dart';
import '../../constant/color.dart';
import '../../constant/constants.dart';
import '../../constant/routes.dart';
class Chat extends StatefulWidget {

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F8),
      appBar: AppBar(
        backgroundColor: ColorInstance.backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          getString(context, 'txt_chat_room'),
          style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Handle'),
        ),
        actions: [Lottie.asset('assets/json/chat.json')],
        elevation: 5,
      ),
      body: StreamBuilder(
        stream: Stream.fromFuture(
          FirebaseFirestoreHelper.instance.getListUsers()),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  color: ColorInstance.backgroundColor),
            );
          }
          if (snapshot.data!.isEmpty ||
              snapshot.data == null ||
              !snapshot.hasData) {
            return Center(
              child: Text(
                getString(context, 'message_chat_room_empty'),
                style: TextStyle(
                    color: ColorInstance.backgroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            );
          }
          return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context,index){
                    Users users = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        child: InkWell(
                          onTap: (){
                            Routes.instance.push(
                                widget: MessageScreen(users: users),
                                context: context);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(users.avatar!),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8,right: 8,bottom: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          users.name,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          users.email,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
          );
        }
        ),
      );
  }
}
