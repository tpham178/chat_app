import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/widget.dart';
import 'convo_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  bool isShowUsers = false;

  createChatRoomAndStartConversation(String userName){
    print(Constants.myName);
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      dataBaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId: chatRoomId,)));
    }else{
      print("you cannot send message to yourself");
    }
  }
  @override
  void initState() {
    super.initState();
  }

  Widget SearchTile({required String userName, required String userEmail}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle(),),
              Text(userEmail, style: mediumTextStyle(),),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message", style: mediumTextStyle(),),
            ),
          ),
        ],
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: appBarMain(context),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: const Color(0x54FFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: searchTextEditingController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: "search username...",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                      border: InputBorder.none,
                    ),
                  )),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isShowUsers = true;
                      });
                    },
                    child: Container(
                      height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png")),
                  )
                ],
              ),
            ),
             SizedBox(
              height: 200.0,
              child: isShowUsers
                  ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where("name", isEqualTo: searchTextEditingController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return SearchTile(userName: (snapshot.data! as dynamic).docs[index]['name'], userEmail: (snapshot.data! as dynamic).docs[index]['email']);
                    },
                  );
                },
              )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}


getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
