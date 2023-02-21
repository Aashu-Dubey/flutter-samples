import 'package:flutter/material.dart';
import 'package:flutter_samples/samples/ui/rive_app/components/hcard.dart';
import 'package:flutter_samples/samples/ui/rive_app/components/vcard.dart';
import 'package:flutter_samples/samples/ui/rive_app/models/courses.dart';
import 'package:flutter_samples/samples/ui/rive_app/theme.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({Key? key}) : super(key: key);

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  final List<CourseModel> _courses = CourseModel.courses;
  final List<CourseModel> _courseSections = CourseModel.courseSections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: RiveAppTheme.background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 60,
              bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Courses",
                  style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ..._courses.map(
                    (course) => Padding(
                      key: course.id,
                      padding: const EdgeInsets.all(10),
                      child: VCard(course: course),
                    ),
                  )
                ]),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Text(
                  "Recent",
                  style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                ),
              ),
              ...List.generate(
                _courseSections.length,
                (index) => Padding(
                  key: _courseSections[index].id,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: HCard(section: _courseSections[index]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
