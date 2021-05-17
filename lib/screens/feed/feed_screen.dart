import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  static const id = 'feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('hello'),
                ),
              ),
            ),
          ),
          child: Text('Feed'),
        ),
      ),
    );
  }
}
