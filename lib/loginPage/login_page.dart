//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';   // icon file
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'Constant.dart';  // for main dart add your colors here

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // old code start from here
      backgroundColor: bgColor,   // change the background color from here
      body: Stack(
        children: [
          // Vector 3D image
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,  // change the position of the image
              child: Image.asset(
                'assets/loginPageImages.jpeg', // Replace with the path image
                height: 540,
                fit: BoxFit.cover,

                // Adjust the height to fit your needs
              ),
            ),
          ),

          // old code starts from here
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 540),
                  Text(
                    "UNDERCOVER",   // text line
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20) ,  // add space using this

                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue,
                  //     onPrimary: Colors.white,
                  //   ),
                  //   onPressed: () {},
                  //   // child: Ink.image(
                  //   //   // image: AssetImage('assets/images/google3dd.png'),
                  //   //   // alignment: Alignment.centerRight,
                  //   //
                  //   //   fit: BoxFit.contain, // Adjust this to your preference
                  //     child: InkWell(
                  //       onTap: () {
                  //         // Handle button press here
                  //       },
                  //       child: Container(
                  //         width: 170, // Set your preferred width
                  //         height: 50, // Set your preferred height
                  //         alignment: Alignment.centerLeft,
                  //         child: Text(
                  //           'CONTINUE WITH GOOGLE',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  //
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                    ),

                    onPressed: () { },
                    child: Text('CONTINUE WITH GOOGLE'),
                  ),


                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () { },
                    child: Text('CONTINUE WITH PHONE'),
                  ),









                  //sign in button
                  // SizedBox(
                  //   width: 300, // Adjust the width of the button section
                  //   child: Container(
                  //     padding: EdgeInsets.all(18),
                  //     decoration: BoxDecoration(
                  //       color: Colors.black,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Image.asset(
                  //           'assets/images/google_icon.png', // Replace with the path to your image icon
                  //           width: 30, // Set the desired width of the image icon
                  //           height: 30, // Set the desired height of the image icon
                  //         ),
                  //         SizedBox(width: 1),
                  //         Text(
                  //           ' Continue With Google',
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 18,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 8),
                  // SizedBox(
                  //   width: 300, // Adjust the width of the button section
                  //   child: Container(
                  //     padding: EdgeInsets.all(20),
                  //     decoration: BoxDecoration(
                  //       color: myColor,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Image.asset(
                  //           'assets/images/call.png', // Replace with the path to your image icon
                  //           width: 30, // Set the desired width of the image icon
                  //           height: 30, // Set the desired height of the image icon
                  //         ),
                  //         SizedBox(width: 1),
                  //         Text(
                  //           '  Continue With Phone',
                  //           style: TextStyle(
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 18,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  // not a member / register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' Register Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
