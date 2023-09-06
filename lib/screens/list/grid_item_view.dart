import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_samples/models/samples.dart';

class GridItemView extends StatelessWidget {
  const GridItemView(
      {super.key, this.index = 0, this.onPressed, required this.listItem});

  final int index;
  final Function? onPressed;
  final SampleData listItem;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      borderRadius: BorderRadius.circular(8),
      padding: EdgeInsets.zero,
      pressedOpacity: 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                listItem.background,
              ),
            ),
            Container(color: Colors.black.withOpacity(0.5)),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  listItem.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      onPressed: () {
        onPressed!();
      },
    );
  }
}
