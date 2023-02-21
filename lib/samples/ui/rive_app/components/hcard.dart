import 'package:flutter/material.dart';
import 'package:flutter_samples/samples/ui/rive_app/models/courses.dart';

class HCard extends StatelessWidget {
  const HCard({Key? key, required this.section}) : super(key: key);

  final CourseModel section;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 110),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
        color: section.color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                      fontSize: 24, fontFamily: "Poppins", color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  section.caption,
                  style: const TextStyle(
                      fontSize: 17, fontFamily: "Inter", color: Colors.white),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: VerticalDivider(thickness: 0.8, width: 0),
          ),
          Image.asset(section.image)
        ],
      ),
    );
  }
}
