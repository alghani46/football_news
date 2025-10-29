import 'package:flutter/material.dart';
import 'menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football News',
      theme: ThemeData(
        // Define a base color scheme for the whole app.
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          // "secondary" is used by things like FloatingActionButton,
          // cards in your Grid, etc.
          secondary: Colors.blueAccent[400],
        ),

        // This just tells Flutter to prefer Material 3 styles if available.
        useMaterial3: true,
      ),

      // This is the first page that will be shown when the app launches.
      home: const MyHomePage(),
    );
  }
}
