import 'package:flutter/material.dart';
import 'package:flutter_samples/models/samples.dart';

class ListItemView extends StatelessWidget {
  const ListItemView({super.key, this.index = 0, this.onPressed});

  final int index;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4.65,
              offset: const Offset(0, 4),
            )
          ]),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.3, color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8)),
                child: Image.asset(
                  SampleData.sampleTypes[index].background,
                  width: 80,
                  height: 80,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SampleData.sampleTypes[index].name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        SampleData.sampleTypes[index].description,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black45),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          onPressed!();
        },
      ),
    );
  }
}
