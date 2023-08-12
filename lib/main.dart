// import 'package:flutter/material.dart';
// import 'package:flutter_samples/screens/samples_list_view.dart';
// import 'package:flutter_samples/samples/ui/rive_app/home.dart';
// import 'package:flutter_samples/samples/animations/grid_magnification/grid_magnification.dart';
// import 'loginPage/login_page.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Samples',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       routes: {
//
//         RiveAppHome.route: (context) => const RiveAppHome(),
//         // GridMagnification.route: (context) => const GridMagnification(),
//       },
//       home: const SamplesListView(
//         title: "Flutter Samples",
//         backEnabled: false,
//       ),
//     );
//   }
// }

// ********************************************************************************************************************************************8
import 'package:flutter/material.dart';
import 'package:flutter_samples/screens/samples_list_view.dart';
import 'package:flutter_samples/samples/ui/rive_app/home.dart';
import 'package:flutter_samples/samples/animations/grid_magnification/grid_magnification.dart';
import 'package:rive/rive.dart';
import 'loginPage/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Samples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        RiveAppHome.route: (context) => const RiveAppHome(),
        // GridMagnification.route: (context) => const GridMagnification(),
      },
      home: AuthWrapper(), // Use AuthWrapper as the initial screen
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // You can implement your authentication logic here
    final bool isLoggedIn = false; // Change this based on your authentication status

    if (isLoggedIn) {
      // If user is logged in, show SamplesListView
      return SamplesListView(
        title: "Flutter Samples",
        backEnabled: false,
      );
    } else {
      // If user is not logged in, show LoginPage
      return LoginPage();
    }
  }
}
