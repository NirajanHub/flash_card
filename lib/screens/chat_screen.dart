import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;
  Firestore _firebaseStore;
  String messageText;

  @override
  void initState() {
    super.initState();
    getUser();

    messageStream();
  }

  void getUser() async {
    _firebaseStore = Firestore.instance;
    final user = await _auth.currentUser();
    if (user != null) {
      _firebaseUser = user;
      print(user);
    }
  }

  void messageStream() async {
    await for (var snapshot
        in _firebaseStore.collection('messages').snapshots())
      for (var message in snapshot.documents) {
        print(message.data);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firebaseStore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  final messages = snapshot.data.documents;
                  List<Text> messagewidgets = [];
                  for (var message in messages) {
                    final messageText = message.data['text'];
                    final messageSender = message.data['sender'];
                    final messageWidget =
                        Text('$messageText from $messageSender');
                    messagewidgets.add(messageWidget);
                  }
                  return Column(
                    children: messagewidgets,
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firebaseStore.collection('messages').add(
                          {'text': messageText, 'sender': _firebaseUser.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
