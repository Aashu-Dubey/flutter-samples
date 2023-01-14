import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_samples/rive_app/models/courses.dart';

class VCard extends StatelessWidget {
  VCard({Key? key, required this.course}) : super(key: key) {
    avatars.shuffle();
  }

  final CourseModel course;
  final avatars = [4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260, maxHeight: 310),
      // width: 260,
      // height: 310,
      padding: const EdgeInsets.all(30),
      // margin: const EdgeInsets.all(10), // Spacing in list
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [course.color, course.color.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(
            color: course.color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: course.color.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // runSpacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 170),
                child: Text(
                  course.title,
                  style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins",
                      // fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ),
              // Spacer(),
              // Image.asset("assets/images/topics/topic_1.png"),
              //   ],
              // ),
              const SizedBox(height: 8),
              /*Flexible(
                // fit: FlexFit.loose,
                child:*/
              Text(
                course.subtitle!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: false,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 15),
              ),
              // ),
              const SizedBox(height: 8),
              Text(
                course.caption.toUpperCase(),
                style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const Spacer(),

              // () {
              //   avatars.shuffle();
              //   return
              Wrap(
                // mainAxisSize: MainAxisSize.min,
                // direction: Axis.horizontal,
                spacing: 8,
                children: avatars
                    .mapIndexed(
                      (index, number) => Transform.translate(
                        offset: Offset(index * -20, 0),
                        child: ClipRRect(
                          key: Key(index.toString()),
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset(
                              "assets/rive_app/images/avatars/avatar_$number.jpg",
                              width: 44,
                              height: 44),
                        ),
                      ),
                    )
                    .toList(),
              )
              // }()

              // ...List.generate(3, (index) => )

              // ClipRRect(
              //     borderRadius: BorderRadius.circular(22),
              //     child: Image.asset("assets/images/avatars/avatar_1.jpg", width: 44, height: 44))
            ],
          ),
          Positioned(right: -10, top: -10, child: Image.asset(course.image))
        ],
      ),
    );
  }
}
