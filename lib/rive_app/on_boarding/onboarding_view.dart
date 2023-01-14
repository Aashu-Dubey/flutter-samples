import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:rive/rive.dart';
import 'package:flutter_samples/rive_app/theme.dart';
import 'package:flutter_samples/rive_app/on_boarding/signin_view.dart';
import 'package:flutter_samples/rive_app/assets.dart' as app_assets;

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key, this.closeModal}) : super(key: key);

  // Close modal callback for any screen that uses this as a modal
  final Function? closeModal;

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView>
    with TickerProviderStateMixin {
  AnimationController? _signInAnimController;

  // Animation<double>? translateAnim;
  // Control touch effect animation for the "Start the Course" button
  late RiveAnimationController _btnController;

  // bool showModal = false;

  @override
  void initState() {
    super.initState();
    _signInAnimController = AnimationController(
        duration: const Duration(milliseconds: 350),
        upperBound: 1,
        vsync: this);
    /*translateAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1, curve: Curves.easeInOut)));*/

    _btnController = OneShotAnimation("active", autoplay: false);

    const springDesc = SpringDescription(
      mass: 0.1,
      stiffness: 40,
      damping: 5,
    );

    _btnController.isActiveChanged.addListener(() {
      // setState(() {
      //   showModal = true;
      // });
      if (!_btnController.isActive) {
        final springAnim = SpringSimulation(springDesc, 0, 1, 0);
        _signInAnimController?.animateWith(springAnim);
        // animationController?.forward();
        /*SchedulerBinding.instance.addPostFrameCallback((_) {
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.4), //SHADOW EFFECT
              transitionBuilder: (context, a1, a2, widget) {
                Tween<Offset> tween = Tween(begin: Offset(0, -1), end: Offset(0, 0));
                // final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                return SlideTransition(
                  // transform: Matrix4.translationValues(0, (MediaQuery.of(context).size.height / 2) * a1.value, 0),
                  position: tween.animate(CurvedAnimation(parent: a1, curve: Curves.easeInOut)),
                  // scale: a1.value,
                  child: widget,
                );
              },
              transitionDuration: Duration(milliseconds: 300), // DURATION FOR ANIMATION
              barrierDismissible: true,
              barrierLabel: 'LABEL',
              context: context,
              // barrierDismissible: true,
              // barrierColor: Colors.red,
              pageBuilder: (_, __, ___) {
                return SignInView(showModal: showModal, onModalClose: () {
                  setState(() {
                    showModal = false;
                  });
                  animationController?.reverse();
                });
              }
          );
        });*/
      }
    });
  }

  @override
  void dispose() {
    _signInAnimController?.dispose();
    _btnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Center(
          //   child: OverflowBox(
          //       // minHeight: 560,
          //       // minWidth: 715,
          //       maxWidth: double.infinity,
          //       child: Transform.translate(
          //         offset: const Offset(200, 100),
          //         child: Image.asset('assets/backgrounds/Spline.png',
          //             fit: BoxFit.cover),
          //       )),
          // ),
          // BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          //   child: Container(
          //     color: Colors.black.withOpacity(0),
          //   ),
          // ),
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Center(
              child: OverflowBox(
                // minHeight: 560,
                // minWidth: 715,
                maxWidth: double.infinity,
                child: Transform.translate(
                  offset: const Offset(200, 100),
                  child: Image.asset(app_assets.spline,
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),

          // const RiveAnimation.asset(
          //   'assets/rive/shapes.riv',
          // ),
          // Apply Blur effect above rive background
          // BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          //   child: Container(
          //     color: Colors.black.withOpacity(0),
          //   ),
          // ),

          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: const RiveAnimation.asset(
              app_assets.shapesRiv,
            ),
          ),

          AnimatedBuilder(
            animation: _signInAnimController!,
            builder: (context, child) {
              /*AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          top: showModal ? -50 : 0,
          bottom: 0,
          left: 0,
          right: 0,
          child:*/
              return Transform(
                transform: Matrix4.translationValues(
                    0, -50 * _signInAnimController!.value, 0),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 260,
                          padding: const EdgeInsets.only(bottom: 16),
                          child: const Text(
                            "Learn design & code",
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 60),
                          ),
                        ),
                        Text(
                          "Don’t skip design. Learn design and code, by building real apps with React and Swift. Complete courses about the best tools.",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontFamily: "Inter",
                              fontSize: 17),
                        ),
                        const SizedBox(height: 16),
                        const Spacer(),
                        GestureDetector(
                          // splashColor: Colors.transparent,
                          // highlightColor: Colors.transparent,
                          // hoverColor: Colors.transparent,
                          // padding: EdgeInsets.zero,
                          child: Container(
                            width: 236,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 10),
                                )
                              ],
                            ),
                            child: Stack(
                              children: [
                                RiveAnimation.asset(
                                  app_assets.buttonRiv,
                                  fit: BoxFit.cover,
                                  controllers: [_btnController],
                                ),
                                Center(
                                  child: Transform.translate(
                                    offset: const Offset(4, 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        // Padding(
                                        //   padding: EdgeInsets.only(right: 4),
                                        //   child:
                                              Icon(Icons.arrow_forward_rounded),
                                        // ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Start the course",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            _btnController.isActive = true;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Purchase includes access to 30+ courses, 240+ premium tutorials, 120+ hours of videos, source files and certificates.",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontFamily: "Inter",
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _signInAnimController!,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: 100 - (_signInAnimController!.value * 180),
                    right: 20,
                    child: SafeArea(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        borderRadius: BorderRadius.circular(36 / 2),
                        minSize: 36,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(36 / 2),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 10))
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.of(context, rootNavigator: true).pop();
                          widget.closeModal!();
                        },
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Opacity(
                        opacity: 0.4 * _signInAnimController!.value,
                        child: Container(color: RiveAppTheme.shadow),
                      ),
                    ),
                  ),
                  Transform.translate(
                    // transform: new Matrix4.translationValues(0, -MediaQuery.of(context).size.height * (1 - animationController!.value), 0),
                    offset: Offset(
                      0,
                      -MediaQuery.of(context).size.height *
                          (1 - _signInAnimController!.value),
                    ),
                    child: SignInView(
                      // showModal: showModal,
                      closeModal: () {
                        // setState(() {
                        //   showModal = false;
                        // });
                        _signInAnimController?.reverse();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
