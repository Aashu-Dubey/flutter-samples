import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'dart:math' as math;
import 'package:flutter_samples/rive_app/navigation/custom_tab_bar.dart';
import 'package:flutter_samples/rive_app/navigation/home_tab_view.dart';
import 'package:flutter_samples/rive_app/on_boarding/onboarding_view.dart';
import 'package:flutter_samples/rive_app/navigation/side_menu.dart';
import 'package:flutter_samples/rive_app/theme.dart';
import 'package:flutter_samples/rive_app/assets.dart' as app_assets;

// Common Tab Scene for the tabs other than 1st one, showing only tab name in center
Widget commonTabScene(String tabName) {
  return Container(
      color: RiveAppTheme.background,
      alignment: Alignment.center,
      child: Text(tabName,
          style: const TextStyle(
              fontSize: 28, fontFamily: "Poppins", color: Colors.black)));
}

class RiveAppHome extends StatefulWidget {
  const RiveAppHome({Key? key}) : super(key: key);

  @override
  State<RiveAppHome> createState() => _RiveAppHomeState();
}

class _RiveAppHomeState extends State<RiveAppHome>
    with TickerProviderStateMixin {
  late AnimationController? _animationController;
  late AnimationController? _onBoardingAnimController;
  late Animation<double> _onBoardingAnim;
  late Animation<double> _sidebarAnim;

  late SMIBool _menuBtn;

  bool _showOnBoarding = false;
  Widget _tabBody = Container(color: RiveAppTheme.background);
  final List<Widget> _screens = [
    const HomeTabView(),
    commonTabScene("Search"),
    commonTabScene("Timer"),
    commonTabScene("Bell"),
    commonTabScene("User"),
  ];

  final springDesc = const SpringDescription(
    mass: 0.1,
    stiffness: 40,
    damping: 5,
  );

  void _onMenuIconInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine");
    artboard.addController(controller!);
    _menuBtn = controller.findInput<bool>("isOpen") as SMIBool;
    _menuBtn.value = true;
  }

  void _presentOnBoarding(bool show) {
    if (show) {
      setState(() {
        _showOnBoarding = true;
      });
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _onBoardingAnimController?.animateWith(springAnim);
    } else {
      _onBoardingAnimController?.reverse().then((value) {
        setState(() {
          _showOnBoarding = false;
        });
      });
    }
  }

  void onMenuPress() {
    if (_menuBtn.value) {
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _animationController?.animateWith(springAnim);
    } else {
      _animationController?.reverse();
    }
    _menuBtn.change(!_menuBtn.value);

    SystemChrome.setSystemUIOverlayStyle(_menuBtn.value
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light);
  }

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), upperBound: 1, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _onBoardingAnimController = AnimationController(
        duration: const Duration(milliseconds: 350), upperBound: 1, vsync: this)
      ..addListener(() {
        setState(() {});
      });

    _sidebarAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    ));
    _onBoardingAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _onBoardingAnimController!,
      curve: Curves.linear,
    ));

    _tabBody = _screens.first;
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _onBoardingAnimController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(children: [
        Positioned(child: Container(color: RiveAppTheme.background2)),
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180),
          child: Transform.translate(
            offset: Offset((1 - _sidebarAnim.value) * -300, 0),
            child: AnimatedOpacity(
              opacity: _sidebarAnim.value * 1,
              duration: const Duration(milliseconds: 200),
              child: const SideMenu(),
            ),
          ),
        ),
        Transform.scale(
          scale: 1 -
              (_showOnBoarding
                  ? (_onBoardingAnim.value * 0.08)
                  : (_sidebarAnim.value * 0.1)),
          child: Transform.translate(
            offset: Offset(_sidebarAnim.value * 265, 0),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY((_sidebarAnim.value * 30) * math.pi / 180),
              child: _tabBody,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          right: (_sidebarAnim.value * -100) + 16,
          child: GestureDetector(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: RiveAppTheme.shadow.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Icon(Icons.person_outline),
            ),
            onTap: () {
              _presentOnBoarding(true);
            },
          ),
        ),
        SafeArea(
          child: Row(children: [
            // There's an issue/behaviour in flutter where translating the GestureDetector or any button
            // doesn't translate the touch area, making the Widget unclickable, so instead setting a SizedBox
            // in a Row to have a similar effect
            SizedBox(width: _sidebarAnim.value * 216),
            GestureDetector(
              onTap: onMenuPress,
              child: Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44 / 2),
                  boxShadow: [
                    BoxShadow(
                      color: RiveAppTheme.shadow.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: RiveAnimation.asset(
                  app_assets.menuButtonRiv,
                  stateMachines: const ["State Machine"],
                  animations: const ["open", "close"],
                  onInit: _onMenuIconInit,
                ),
              ),
            ),
          ]),
        ),
        if (_showOnBoarding)
          Transform.translate(
            offset: Offset(
                0,
                -(MediaQuery.of(context).size.height +
                        MediaQuery.of(context).padding.bottom) *
                    (1 - _onBoardingAnim.value)),
            child: SafeArea(
              top: false,
              maintainBottomViewPadding: true,
              child: Container(
                transform: Matrix4.translationValues(
                    0, -(MediaQuery.of(context).padding.bottom + 18), 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 40,
                        offset: const Offset(0, 40))
                  ],
                ),
                child: OnBoardingView(
                  closeModal: () {
                    _presentOnBoarding(false);
                  },
                ),
              ),
            ),
          ),
        // White underlay behind the bottom tab bar
        IgnorePointer(
          ignoring: true,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  RiveAppTheme.background.withOpacity(0),
                  RiveAppTheme.background.withOpacity(1 -
                      ((!_showOnBoarding
                              ? _sidebarAnim.value
                              : _onBoardingAnim.value) *
                          1))
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: Transform.translate(
        offset: Offset(
            0,
            !_showOnBoarding
                ? _sidebarAnim.value * 300
                : _onBoardingAnim.value * 200),
        child: CustomTabBar(
          onTabChange: (tabIndex) {
            setState(
              () {
                _tabBody = _screens[tabIndex];
              },
            );
          },
        ),
      ),
    );
  }
}
