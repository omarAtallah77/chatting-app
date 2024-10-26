import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'chat_model.dart';

class ChatScreen_2 extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen_2> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  String myname = "Chat1" ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0 ,
          title: Text('Chat' , style: TextStyle(color: Colors.white60)) , centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.amber), // Back icon
              onPressed: () => Navigator.of(context).pushReplacementNamed('/home') )),
      body: Container(
        color: Colors.grey,
        child: Column(
            children:  [
              Expanded (
                child: ListView.builder(
                    itemCount:  messages.length,
                    itemBuilder: (_,index) => BubbleSpecialThree(
                      text: messages[index].toString(),
                      color: Color(0xFF1B97F3) ,
                      tail: true,
                      isSender:  true,
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    )
                ),
              ),Container(
                padding: EdgeInsets.all(15.0),
                color: Colors.black87,
                height: 80,
                child: Row(
                  children: [
                    Expanded (
                        child: TextField(
                          controller: _controller, decoration: InputDecoration(
                          labelText: "Message",
                          labelStyle: TextStyle(color: Colors.white60),
                          filled: true,
                          fillColor: Colors.grey[800],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                          style: TextStyle(color: Colors.white),
                        ) ),
                    IconButton(onPressed: () => _sendMessage() ,icon : Icon(Icons.send) , color: Colors.amber)],
                ),
              )
            ]
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState (() {
        messages.add(_controller.text);
        _controller.clear();
      });
    }
  }
}
