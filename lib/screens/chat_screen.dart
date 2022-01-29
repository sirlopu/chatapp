import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

//const _FIRESTORE_COLLECTION = 'chat/NBIOtRs4YYHUcKydDbBP/messages';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // @override
// void initState() {
//     super.initState();
//     final fbm = FirebaseMessaging.instance;
//     fbm.requestPermission();
//     FirebaseMessaging.onMessage.listen((message) {
//       print(message);
//       return;
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//        print(message);
//       return;
//     });
//     fbm.subscribeToTopic('chat');
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Chat',
          style: TextStyle(
              //color: Colors.white,
              ),
        ),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(children: [
                    Icon(
                      Icons.exit_to_app,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ]),
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      )),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       Firestore.instance
      //           .collection(_FIRESTORE_COLLECTION)
      //           .add({'text': 'This was added by the + sign'});
      //     }),
    );
  }
}
