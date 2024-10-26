import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for email input
  final TextEditingController _emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _emailController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  // Function to show the email input dialog
  void _showEmailInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Start a New Chat'),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Enter email',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
        ElevatedButton(
        onPressed: () async {
        final email = _emailController.text.trim();
        if (email.isNotEmpty) {
        var querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
        var userId = querySnapshot.docs[0].id; // Get user ID
        Navigator.of(context).push(
        MaterialPageRoute(
        builder: (context) => ChatScreen(
        currentUserId: 'YOUR_CURRENT_USER_ID', // Pass current user ID
        chatUserId: userId, // Pass the chat user ID
        chatUserEmail: email, // Pass the chat user email
        ),
        ),
        );
        } else {
        _showErrorDialog('User not found');
        }
        }
        // Do NOT close the dialog here; it will be closed when the dialog button is pressed.
        },
        child: Text('Start Chat'),
        ),
          ],
        );
      },
    );
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Home', style: TextStyle(color: Colors.amber)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Placeholder for chat list items
                  // Here you can fetch and display the user's chats
                  // Example:
                  // ListTile(title: Text('Chat with User X')),
                  // ListTile(title: Text('Chat with User Y')),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEmailInputDialog,
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}
