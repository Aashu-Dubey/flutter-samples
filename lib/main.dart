import 'package:flutter/material.dart';
import 'package:flutter_samples/screens/samples_list_view.dart';
import 'package:flutter_samples/samples/ui/rive_app/home.dart';
import 'package:flutter_samples/samples/animations/grid_magnification/grid_magnification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Samples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        RiveAppHome.route: (context) => const RiveAppHome(),
        GridMagnification.route: (context) => const GridMagnification(),
      },
      home: const SamplesListView(
        title: "Flutter Samples",
        backEnabled: false,
      ),
    );
  }
}
