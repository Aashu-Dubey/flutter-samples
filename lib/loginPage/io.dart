import 'package:flutter/material.dart';

const Color myColor = Color(0xFFF87A7A);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Google Icon with Text')),
        body: CenteredContainer(),
      ),
    );
  }
}

class CenteredContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: GestureDetector(
        onTap: () {
          // Implement the action when the container is tapped.
          print('Container Tapped!');
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: myColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, color: Colors.black), // Google icon
              SizedBox(width: 8), // Add some space between the icon and the text
              Text(
                'Continue With Phone',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
