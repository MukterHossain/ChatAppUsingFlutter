import 'package:chatappuf/helper/Constants.dart';
import 'package:chatappuf/services/database.dart';
import 'package:chatappuf/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScr extends StatefulWidget {
  final String chatRoomId;
  // ignore: use_key_in_widget_constructors
  const ConversationScr({required this.chatRoomId});

  @override
  _ConversationScrState createState() => _ConversationScrState();
}

class _ConversationScrState extends State<ConversationScr> {
  late QuerySnapshot chats;
  TextEditingController messageTextController = new TextEditingController();

  Widget chatMessages() {
    return ListView.builder(
            itemCount: chats.docs.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: chats.docs[index].get("message"),
                sendByMe: Constants.myName == chats.docs[index].get("sendBy"),
              );
            });
  }

  sendMessage() {
    if (messageTextController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageTextController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageTextController.text = "";
      });
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(widget.chatRoomId)
        .collection("chats")
        .orderBy('time')
        .get()
        .then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageTextController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type Messages",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF)
                              ]),
                              borderRadius: BorderRadius.circular(40)),
                          child: Image.asset("assets/images/send.png")),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
