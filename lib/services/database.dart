import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // getUserByUsername(String username) async {

  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .where("name", isEqualTo: username)
  //       .get()
  //       .then((value) {
  //     return value;
  //   });
  // }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatroomid, chatroomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatroomid)
        .set(chatroomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

    Future<void> addMessage(String chatRoomId, chatMessageData)async {

    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
          print(e.toString());
    });
  }
}
