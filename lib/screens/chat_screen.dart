import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatScreen extends StatefulWidget {
  static const id = 'chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

Firestore _firebaseStore;
FirebaseUser _firebaseUser;

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;

  bool isMe = false;
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
            StreamBuilderWidget(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: TextField(
                        controller: messageTextController,
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
                      messageTextController.clear();
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

class MessageBubble extends StatelessWidget {
  String text;
  String sender;
bool isMe;
  MessageBubble({this.text, this.sender,this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(color: isMe ? Colors.grey : Colors.black),
          ),
          Material(
              borderRadius: BorderRadius.only(
                  topLeft: isMe ? Radius.circular(30.0) : Radius.circular(0.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topRight:
                      isMe ? Radius.circular(30.0) : Radius.circular(0.0)),
              color: isMe ? Colors.lightBlueAccent : Colors.black12,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Text(
                  '$text',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}

class StreamBuilderWidget extends StatelessWidget {

  bool isMe = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseStore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          final currentUser = _firebaseUser.email;

          List<MessageBubble> messagewidgets = [];
          for (var message in messages) {
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];
            final messageWidget =
                MessageBubble(text: messageText, sender: messageSender,isMe:currentUser == messageSender);
            messagewidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: false,
              children: messagewidgets,
            ),
          );
        });
  }
}
