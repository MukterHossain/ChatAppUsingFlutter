import 'package:chatappuf/helper/Constants.dart';
import 'package:chatappuf/services/database.dart';
import 'package:chatappuf/views/ConversationScreen.dart';
import 'package:chatappuf/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScr extends StatefulWidget {
  const SearchScr({Key? key}) : super(key: key);

  @override
  _SearchScrState createState() => _SearchScrState();
}

class _SearchScrState extends State<SearchScr> {
  TextEditingController searchTextEdController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool searchshow = false;
  late QuerySnapshot data;
  initiateSearch() {
    FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: searchTextEdController.text)
        .get()
        .then((value) {
      setState(() {
        data = value;
        searchshow = true;
      });
    });
  }

  Widget SearchList() {
    return searchshow
        ? ListView.builder(
            itemCount: data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                  data.docs[0].get("name"), data.docs[0].get("email"),context);
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchTextEdController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter UserName",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
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
                        child: Image.asset("assets/images/search_white.png")),
                  ),
                ],
              ),
            ),
            SearchList(),
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String email;
  final contxt;
  SearchTile(this.userName, this.email,this.contxt);

  DatabaseMethods databaseMethods = new DatabaseMethods();

  createChatroomAndCoversation(String userName) {
    String chatroomId = "${userName+Constants.myName}";
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomid": chatroomId,
    };
    databaseMethods.createChatRoom(chatroomId, chatRoomMap);
    Navigator.pushReplacement(
        contxt,
        MaterialPageRoute(
            builder: (context) => ConversationScr(
                  chatRoomId: chatroomId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: simpleTextStyle(),
              ),
              Text(
                email,
                style: simpleTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndCoversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: simpleTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(1) > b.substring(0, 1).codeUnitAt(1)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
