import 'package:flutter/material.dart';
import 'package:flutter_samples/samples/ui/rive_app/home.dart';

class SampleData {
  SampleData(
      {this.name = "",
      this.description = "",
      this.background = "",
      this.navigateScreen});

  String name;
  String description;
  String background;
  Widget? navigateScreen;

  static List<SampleData> sampleTypes = [
    SampleData(
        name: 'UI',
        description: 'Full application UI samples with some interesting animations and challenges.',
        background: 'assets/samples/ui/rive_app/course_rive.png',
        navigateScreen: const RiveAppHome()),
    // SampleData(
    //     name: 'Animations',
    //     description: 'Samples showcasing some interesting and complex animations in flutter.',
    //     background: 'assets/samples/animations/grid_magnification.png')
  ];
}
