import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter_samples/samples/ui/rive_app/theme.dart';
import 'package:flutter_samples/samples/ui/rive_app/on_boarding/signin_view.dart';
import 'package:flutter_samples/samples/ui/rive_app/assets.dart' as app_assets;

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key, this.closeModal});

  // Close modal callback for any screen that uses this as a modal
  final Function? closeModal;

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView>
    with TickerProviderStateMixin {
  // Animation controller that shows the sign up modal as well as translateY boarding content together
  AnimationController? _signInAnimController;

  late rive.File file;
  late rive.File shapesFile;
  rive.Artboard? artboard;
  rive.Artboard? shapesArtboard;
  late rive.SingleAnimationPainter painter;
  late rive.SingleAnimationPainter shapesPainter;

  final springDesc = SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  @override
  void initState() {
    super.initState();
    _signInAnimController = AnimationController(
        duration: const Duration(milliseconds: 350),
        upperBound: 1,
        vsync: this);

    initRiveAssets();
  }

  void initRiveAssets() async {
    // The shapes artboard sits under an ImageFiltered blur. Flutter image
    // filters cannot reach a Rive render texture (a platform view on web), so
    // the blur only applies with the Flutter renderer.
    shapesFile = (await rive.File.asset(app_assets.shapesRiv, riveFactory: kIsWeb ? rive.Factory.flutter : rive.Factory.rive))!;
    shapesPainter = rive.SingleAnimationPainter('Animation 1');
    shapesArtboard = shapesFile.defaultArtboard();

    file = (await rive.File.asset(app_assets.buttonRiv, riveFactory: rive.Factory.rive))!;
    initBtnPainer();
    setState(() {});
  }

  void initBtnPainer() {
    painter = rive.SingleAnimationPainter('active', fit: rive.Fit.cover);
    artboard = file.defaultArtboard();
  }

  void startCourseBtnPress() {
    painter.dispose();
    artboard?.dispose();
    initBtnPainer();
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _signInAnimController?.animateWith(springAnim);
    });
    setState(() {}); // rebuild RiveArtboardWidget with new painter
  }

  @override
  void dispose() {
    _signInAnimController?.dispose();

    painter.dispose();
    shapesPainter.dispose();
    artboard?.dispose();
    shapesArtboard?.dispose();
    file.dispose();
    shapesFile.dispose();
    // Web-only: purges the pooled render textures (and the WebGL contexts they
    // keep alive) left behind by the sheet; a no-op on other platforms.
    rive.RiveNative.instance.releaseRenderResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Center(
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Transform.translate(
                offset: const Offset(200, 100),
                child: Image.asset(app_assets.spline, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        if (shapesArtboard != null)
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: rive.RiveArtboardWidget(
              artboard: shapesArtboard!,
              painter: shapesPainter,
            ),
          ),
        AnimatedBuilder(
          animation: _signInAnimController!,
          builder: (context, child) {
            return Transform(
                transform: Matrix4.translationValues(
                    0, -50 * _signInAnimController!.value, 0),
                child: child);
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 260,
                            padding: const EdgeInsets.only(bottom: 16),
                            child: const Text(
                              "Learn design & code",
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 60),
                            ),
                          ),
                          Text(
                            "Don’t skip design. Learn design and code, by building real apps with React and Swift. Complete courses about the best tools.",
                            style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.7),
                                fontFamily: "Inter",
                                fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // const Spacer(),
                  GestureDetector(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 236,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            if (artboard != null)
                              rive.RiveArtboardWidget(
                                artboard: artboard!,
                                painter: painter,
                              ),
                            Center(
                              child: Transform.translate(
                                offset: const Offset(4, 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.arrow_forward_rounded),
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
                    ),
                    onTap: () {
                      startCourseBtnPress();
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Purchase includes access to 30+ courses, 240+ premium tutorials, 120+ hours of videos, source files and certificates.",
                    style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.7),
                        fontFamily: "Inter",
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _signInAnimController!,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                      top: 100 - (_signInAnimController!.value * 200),
                      right: 20,
                      child: SafeArea(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(36 / 2),
                          minimumSize: Size(36, 36),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(36 / 2),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
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
                            widget.closeModal!();
                          },
                        ),
                      )),
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
                    offset: Offset(
                      0,
                      -MediaQuery.of(context).size.height *
                          (1 - _signInAnimController!.value),
                    ),
                    child: child,
                  ),
                ],
              );
            },
            child: SignInView(
              closeModal: () {
                _signInAnimController?.reverse();
              },
            ),
          ),
        ),
      ]),
    );
  }
}
