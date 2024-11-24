import 'package:flutter/material.dart';
import 'package:http/http.dart' ;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RandomPostScreen(),
    );
  }
}

class RandomPostScreen extends StatefulWidget {
  @override
  _RandomPostScreenState createState() => _RandomPostScreenState();
}

class _RandomPostScreenState extends State<RandomPostScreen> {
  bool isLoading = false; // Track loading state
  String postTitle = ""; // Store fetched post title

  // Fetch random post from JSONPlaceholder
  Future<void> fetchPost() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'), // Fixed ID for simplicity
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          postTitle = data['title'];
        });
      } else {
        setState(() {
          postTitle = "Failed to load post.";
        });
      }
    } catch (e) {
      setState(() {
        postTitle = "Error: $e";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Post'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show loading spinner
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              postTitle.isEmpty ? "Press the button to fetch a post!" : postTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchPost,
              child: Text('Fetch Post'),
            ),
          ],
        ),
      ),
    );
  }
}
