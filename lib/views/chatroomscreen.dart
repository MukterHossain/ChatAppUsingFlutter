import 'package:chatappuf/helper/Constants.dart';
import 'package:chatappuf/helper/authenticate.dart';
import 'package:chatappuf/helper/helperFuctions.dart';
import 'package:chatappuf/services/auth.dart';
import 'package:chatappuf/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoomScr extends StatefulWidget {
  const ChatRoomScr({Key? key}) : super(key: key);

  @override
  _ChatRoomScrState createState() => _ChatRoomScrState();
}

class _ChatRoomScrState extends State<ChatRoomScr> {
  AuthMethods authMethods = AuthMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFuctions.getUserNameSharedPreference())!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Image.asset(
                "assets/images/logo.png",
                height: 50,
              ),
              actions: [
                GestureDetector(
                    onTap: () {
                      authMethods.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Authenticate(),
                          ));
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.exit_to_app)))
              ],
            ),
            preferredSize: Size.fromHeight(55)),
        body: Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (Context) => SearchScr(),
                ));
          },
          child: Icon(Icons.search),
        ));
  }
}
