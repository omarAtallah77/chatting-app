import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String chatUserId;
  final String chatUserEmail;

  ChatScreen({
    required this.currentUserId,
    required this.chatUserId,
    required this.chatUserEmail,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: Text(
          'Chat with ${widget.chatUserEmail}',
          style: TextStyle(color: Colors.white60),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(_getChatId())
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true, // Show the latest messages at the bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var messageData = messages[index];
                      bool isSender = messageData['senderId'] == widget.currentUserId;

                      return BubbleSpecialThree(
                        text: messageData['text'],
                        color: isSender ? Color(0xFF1B97F3) : Colors.grey[700]!,
                        tail: true,
                        isSender: isSender,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(15.0),
      color: Colors.black87,
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
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
              onSubmitted: (_) => _sendMessage(), // Send message on enter
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  // Function to generate unique chat ID based on user IDs
  String _getChatId() {
    return widget.currentUserId.hashCode <= widget.chatUserId.hashCode
        ? '${widget.currentUserId}_${widget.chatUserId}'
        : '${widget.chatUserId}_${widget.currentUserId}';
  }

  // Send message to Firestore
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String messageText = _controller.text;
      String chatId = _getChatId(); // Get the unique chat ID

      // Create the message data
      Map<String, dynamic> messageData = {
        'text': messageText,
        'senderId': widget.currentUserId,
        'receiverId': widget.chatUserId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save the message to the chat for both users
      _firestore.collection('chats').doc(chatId).collection('messages').add(messageData)
          .then((value) {
        print("Message sent: $messageText");
      }).catchError((error) {
        print("Failed to send message: $error");
      });

      // Optionally, save the last message in user-specific collections
      _firestore
          .collection('users')
          .doc(widget.currentUserId)
          .collection('chats')
          .doc(chatId)
          .set({
        'lastMessage': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'chatUserId': widget.chatUserId,
      }, SetOptions(merge: true));

      _firestore
          .collection('users')
          .doc(widget.chatUserId)
          .collection('chats')
          .doc(chatId)
          .set({
        'lastMessage': messageText,
        'timestamp': FieldValue.serverTimestamp(),
        'chatUserId': widget.currentUserId,
      }, SetOptions(merge: true));

      _controller.clear(); // Clear the text field after sending the message
    }
  }



}

