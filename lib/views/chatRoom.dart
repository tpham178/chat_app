import 'package:chat_app/views/convo_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/search.dart';
import 'package:flutter/material.dart';

import '../helper/helperfunctions.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            return ChatRoomTile(userName : (snapshot.data! as dynamic).docs[index]["chatRoomId"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""), chatRoomId: (snapshot.data! as dynamic).docs[index]["chatRoomId"],);
          },
        );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = (await HelperFunction.getUserNameSharedPreference())!;
    dataBaseMethods.getChatRoom(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",
          height: 50,),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              HelperFunction.saveUserLoggedInSharedPreference(false);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => const Authenticate()
              ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  const ChatRoomTile({Key? key, required this.userName, required this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId: chatRoomId)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(userName.substring(0,1).toUpperCase(), style: mediumTextStyle(),),
            ),
            const SizedBox(width: 8,),
            Text(userName, style: mediumTextStyle(),),
          ],
        ),
      ),
    );
  }
}

