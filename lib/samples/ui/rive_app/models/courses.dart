import 'package:flutter/material.dart';
import 'package:flutter_samples/samples/ui/rive_app/assets.dart' as app_assets;

class CourseModel {
  CourseModel(
      {this.id,
      this.title = "",
      this.subtitle = "",
      this.caption = "",
      this.color = Colors.white,
      this.image = ""});

  UniqueKey? id = UniqueKey();
  String title, caption, image;
  String? subtitle;
  Color color;

  static List<CourseModel> courses = [
    CourseModel(
        title: "Animations in SwiftUI",
        subtitle: "Build and animate an iOS app from scratch",
        caption: "20 sections - 3 hours",
        color: const Color(0xFF7850F0),
        image: app_assets.topic_1),
    CourseModel(
        title: "Build Quick Apps with SwiftUI",
        subtitle:
            "Apply your Swift and SwiftUI knowledge by building real, quick and various applications from scratch",
        caption: "47 sections - 11 hours",
        color: const Color(0xFF6792FF),
        image: app_assets.topic_2),
    CourseModel(
        title: "Build a SwiftUI app for iOS 15",
        subtitle:
            "Design and code a SwiftUI 3 app with custom layouts, animations and gestures using Xcode 13, SF Symbols 3, Canvas, Concurrency, Searchable and a whole lot more",
        caption: "21 sections - 4 hours",
        color: const Color(0xFF005FE7),
        image: app_assets.topic_1),
  ];

  static List<CourseModel> courseSections = [
    CourseModel(
        title: "State Machine",
        caption: "Watch video - 15 mins",
        color: const Color(0xFF9CC5FF),
        image: app_assets.topic_2),
    CourseModel(
        title: "Animated Menu",
        caption: "Watch video - 10 mins",
        color: const Color(0xFF6E6AE8),
        image: app_assets.topic_1),
    CourseModel(
        title: "Tab Bar",
        caption: "Watch video - 8 mins",
        color: const Color(0xFF005FE7),
        image: app_assets.topic_2),
    CourseModel(
        title: "Button",
        caption: "Watch video - 9 mins",
        color: const Color(0xFFBBA6FF),
        image: app_assets.topic_1),
  ];
}
