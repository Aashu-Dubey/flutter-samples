import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_samples/samples/animations/grid_magnification/icons.dart'
    as icons;

double boxSize = 20 + 12; // 12 = padding
double radius = 130;

class TouchPoints {
  final double? x;
  final double? y;

  TouchPoints({required this.x, required this.y});
}

class GridMagnification extends StatefulWidget {
  const GridMagnification({Key? key}) : super(key: key);

  static const String route = '/grid-magnification';

  @override
  State<GridMagnification> createState() => _GridMagnificationState();
}

class _GridMagnificationState extends State<GridMagnification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gridAnim;
  TouchPoints? touchPos;

  var springDesc = const SpringDescription(
    mass: 0.8,
    stiffness: 100,
    damping: 20,
  );

  void onTouchUpdate(touchDetails, {isContinuous = false, isEnded = false}) {
    /// Record the touch coordinates while touch is active
    if (!isEnded) {
      setState(() {
        touchPos = TouchPoints(
            x: touchDetails.localPosition.dx, y: touchDetails.localPosition.dy);
      });
    }

    /// When Touch start or ends
    if (!isContinuous) {
      if (!isEnded) {
        final springAnim = SpringSimulation(springDesc, 0, 1, 0);
        _controller.animateWith(springAnim);
      } else {
        _controller.animateBack(0, duration: const Duration(milliseconds: 300));
      }
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _gridAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;

    /// subtracting padding to ignore safe area (portrait or landscape), 32 == margin
    var viewWidth = size.width - padding.left - padding.right - 32;
    var viewHeight = size.height - padding.top - padding.bottom - 32;

    var maxCol = viewWidth ~/ boxSize;
    var maxRow = viewHeight ~/ boxSize;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Align(
              child: GestureDetector(
                onPanDown: (details) {
                  onTouchUpdate(details);
                },
                onPanUpdate: (details) {
                  onTouchUpdate(details, isContinuous: true);
                },
                onPanEnd: (details) {
                  onTouchUpdate(details, isEnded: true);
                },
                child: SizedBox(
                  width: maxCol * boxSize,
                  height: maxRow * boxSize,
                  child: GridView.count(
                    crossAxisCount: maxCol,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      maxCol * maxRow,
                      (index) => BoxItem(
                          maxCol: maxCol,
                          index: index,
                          touchPos: touchPos,
                          animationController: _controller,
                          gridAnim: _gridAnim),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class BoxItem extends StatefulWidget {
  final int index;
  final int maxCol;
  final TouchPoints? touchPos;
  final AnimationController animationController;
  final Animation gridAnim;

  const BoxItem(
      {this.index = 0,
      this.maxCol = 0,
      this.touchPos,
      required this.animationController,
      required this.gridAnim,
      Key? key})
      : super(key: key);

  @override
  State<BoxItem> createState() => _BoxItemState();
}

class _BoxItemState extends State<BoxItem> {
  late String boxIcon;
  double distance = 0.0;
  double translateX = 0.0, translateY = 0.0;
  double? scaleVal = 1;

  @override
  void initState() {
    /// Initially get indexed icon, but if more then icons array length then get a random index
    boxIcon = widget.index < icons.appIcons.length
        ? icons.appIcons[widget.index]
        : icons.appIcons[math.Random().nextInt(icons.appIcons.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var row = widget.index ~/ widget.maxCol;
    var col = widget.index % widget.maxCol;
    var posX = col * boxSize + (boxSize / 2);
    var posY = row * boxSize + (boxSize / 2);
    var distance = 0.0;
    if (widget.touchPos != null) {
      /// Getting distance between two points using equation, d=√((x2 – x1)² + (y2 – y1)²)
      distance = math.sqrt(math.pow(widget.touchPos!.x! - posX, 2) +
          math.pow(widget.touchPos!.y! - posY, 2));
    }

    if (widget.touchPos != null) {
      /// Here 'touchPos.value.(x/y) - pos(X/Y)' will translate a particular item to the touch point, then multiplying
      /// that value with this median (correct name?) will distribute items to a distance, basically forming a Circle.
      var median = (distance - radius) / radius;

      // translateX = (distance / RADIUS) * (touchPos.value.x - posX) * median;
      // translateY = (distance / RADIUS) * (touchPos.value.y - posY) * median;
      translateX = (widget.touchPos!.x! - posX) * median;
      translateY = (widget.touchPos!.y! - posY) * median;

      /// Clamp the translate value to the touch point if it is getting past that.
      if (translateX.abs() > (widget.touchPos!.x! - posX).abs()) {
        translateX = widget.touchPos!.x! - posX;
      }
      if (translateY.abs() > (widget.touchPos!.y! - posY).abs()) {
        translateY = widget.touchPos!.y! - posY;
      }

      /// Ref: https://stackoverflow.com/a/929107
      double getRange(double min, double max) =>
          (((distance - min) * (1 - 0)) / (max - min)) + 0;

      /// This is basically same as
      /// interpolate({
      ///   value: distance,
      ///   inputRange: [0, 0.01, RADIUS / 3, RADIUS / 2, RADIUS],
      ///   outputRange: [1, 3, 2, 1, 0.15]})
      ///
      /// Currently setting the scaling hard coded (3, 2, 1) and it seems to be working fine for different radius.
      /// Make it dynamic?
      if (distance >= 0 && distance < 0.01) {
        scaleVal = lerpDouble(1, 3, getRange(0, 0.01));
      } else if (distance >= 0.01 && distance < radius / 3) {
        scaleVal = lerpDouble(3, 2, getRange(0.01, radius / 3));
      } else if (distance >= radius / 3 && distance < radius / 2) {
        scaleVal = lerpDouble(2, 1, getRange(radius / 3, radius / 2));
      } else if (distance >= radius / 2 && distance < radius) {
        scaleVal = lerpDouble(1, 0.15, getRange(radius / 2, radius));
      } else if (distance >= radius) {
        scaleVal = 0.15;
      }
    }

    return AnimatedBuilder(
      key: UniqueKey(),
      animation: widget.animationController,
      builder: (c, child) {
        return Transform.translate(
            offset: Offset(translateX * widget.gridAnim.value,
                translateY * widget.gridAnim.value),
            child: Transform.scale(
                scale: 1.0 - ((1 - scaleVal!) * widget.gridAnim.value),
                child: child));
      },
      child: Container(
        width: boxSize,
        height: boxSize,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          // child: Image.network(boxIcon, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
