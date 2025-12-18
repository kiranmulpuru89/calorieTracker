import 'package:flutter/material.dart';

void main() {
  print('=== SIMPLE MAIN CALLED ===');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('=== MyApp building ===');
    return MaterialApp(
      title: 'Test App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test Screen'),
        ),
        body: const Center(
          child: Text('If you see this, Flutter is working!'),
        ),
      ),
    );
  }
}
