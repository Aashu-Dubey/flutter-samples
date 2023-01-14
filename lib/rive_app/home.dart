// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'dart:math' as math;
import 'package:flutter_samples/rive_app/navigation/custom_tab_bar.dart';
import 'package:flutter_samples/rive_app/navigation/home_tab_view.dart';
import 'package:flutter_samples/rive_app/on_boarding/onboarding_view.dart';
import 'package:flutter_samples/rive_app/theme.dart';
import 'package:flutter_samples/rive_app/navigation/side_menu.dart';
import 'package:flutter_samples/rive_app/assets.dart' as app_assets;

class RiveAppHome extends StatefulWidget {
  const RiveAppHome({Key? key}) : super(key: key);

  @override
  State<RiveAppHome> createState() => _RiveAppHomeState();
}

class _RiveAppHomeState extends State<RiveAppHome>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  AnimationController? _onBoardingAnimController;
  late Animation<double> _onBoardingAnim;
  late Animation<double> _sidebarAnim;

  // late Animation<double> _screenMenuScale;
  // late Animation<double> _screenScale;
  // bool isMenuOpen = false;
  bool showOnBoarding = false;
  late SMIBool _menuBtn;
  Widget _tabBody = Container(color: RiveAppTheme.background);
  final List<Widget> _screens = [
    const HomeTabView(),
    const Center(child: Text("Search", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Timer", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Bell", style: TextStyle(color: Colors.white))),
    const Center(child: Text("User", style: TextStyle(color: Colors.white)))
  ];

  void _onMenuIconInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, "State Machine");
    artboard.addController(controller!);
    _menuBtn = controller.findInput<bool>("isOpen") as SMIBool;
    _menuBtn.value = true;
  }

  void _showOnBoarding(bool show) {
    if (show) {
      setState(() {
        showOnBoarding = true;
      });
      const springDesc = SpringDescription(
        mass: 0.1,
        stiffness: 40,
        damping: 5,
      );
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _onBoardingAnimController?.animateWith(springAnim);
    } else {
      _onBoardingAnimController?.reverse().then((value) {
        setState(() {
          showOnBoarding = false;
        });
      });
    }
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
    /*_screenMenuScale = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(
      parent: animationController!,
      curve: Curves.linear,
    ));
    _screenScale = Tween<double>(begin: 1, end: 0.92).animate(CurvedAnimation(
      parent: onBoardingAnimController!,
      curve: Curves.fastOutSlowIn,
    ));*/

    // _slideAnimation = Tween(begin: Offset(0, 0), end: Offset(0, -3)).animate(CurvedAnimation(
    //   parent: _slideAnimationController,
    //   curve: Curves.easeInOut,
    // ));

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
      // resizeToAvoidBottomInset: false,
      body: /*AnimatedBuilder(
        animation: animationController!,
        builder: (context, child) {
          return*/
          Stack(
        children: [
          Positioned(child: Container(color: RiveAppTheme.background2)),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              // ..rotateX(0)
              ..rotateY(((1 - _sidebarAnim!.value) * -30) * math.pi / 180),
            // ..rotateZ(0)
            // ..rotate(vector.Vector3(0, 1, 0), 30 * math.pi / 180),
            child: Transform.translate(
              offset: Offset((1 - _sidebarAnim!.value) * -300, 0),
              child: AnimatedOpacity(
                opacity: _sidebarAnim!.value * 1,
                duration: const Duration(milliseconds: 200),
                child: const SideMenu(),
              ),
            ),
          ),
          Transform.scale(
            scale: 1 -
                (showOnBoarding
                    ? (_onBoardingAnim.value * 0.08)
                    : (_sidebarAnim.value * 0.1)),
            // scale: showOnBoarding ? _screenScale : _screenMenuScale,
            child: Transform.translate(
              offset: Offset(_sidebarAnim!.value * 265, 0),
              // alignment: Alignment.center,
              // transform: Matrix4.translationValues(265, 0, 0),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  // ..rotateX(0)
                  ..rotateY((_sidebarAnim!.value * 30) * math.pi / 180),
                // ..rotateZ(0)
                // ..rotate(vector.Vector3(0, 1, 0), 30 * math.pi / 180),
                child: _tabBody,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: (_sidebarAnim!.value * -100) + 16,
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
                _showOnBoarding(true);
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                // There's an issue/behaviour in flutter where translating the GestureDetector or any button
                // doesn't translate the touch area, making the Widget unclickable, so instead setting a SizedBox
                // in a Row to have a similar effect
                SizedBox(width: _sidebarAnim!.value * 216),
                /*Transform.translate(
                    offset: Offset(animationController!.value * 216, 0),
                    child:*/
                GestureDetector(
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
                  /*onPressed: () {
                        _menuBtn.change(!_menuBtn.value);
                        // _menuBtnController.isActive = !_menuBtnController.isActive;
                      },*/
                  onTap: () {
                    // setState(() {
                    //   isMenuOpen = !isMenuOpen;
                    // });
                    if (_menuBtn.value) {
                      final springAnim = SpringSimulation(
                          const SpringDescription(
                            mass: 0.1,
                            stiffness: 40,
                            damping: 5,
                          ),
                          0,
                          1,
                          0);
                      _animationController?.animateWith(springAnim);
                    } else {
                      _animationController?.reverse();
                    }
                    _menuBtn.change(!_menuBtn.value);

                    SystemChrome.setSystemUIOverlayStyle(_menuBtn.value
                        ? SystemUiOverlayStyle.dark
                        : SystemUiOverlayStyle.light);
                  },
                ),
                // ),
              ],
            ),
          ),
          if (showOnBoarding)
          AnimatedBuilder(
            animation: _onBoardingAnimController!,
            builder: (context, child) {
              return Transform.translate(
                // transform: new Matrix4.translationValues(0, -MediaQuery.of(context).size.height * (1 - animationController!.value), 0),
                offset: Offset(
                    0,
                    -(MediaQuery.of(context).size.height +
                            MediaQuery.of(context).padding.bottom) *
                        (1 - _onBoardingAnimController!.value)),
                // top: -MediaQuery.of(context).size.height *
                //     (1 - onBoardingAnimController!.value),
                // bottom: 0,
                child: SafeArea(
                  top: false,
                  maintainBottomViewPadding: true,
                  child: Transform.translate(
                    offset: Offset(0,
                        -((MediaQuery.of(context).padding.bottom - 60) + 10)),
                    child: Container(
                      // transform: Matrix4.translationValues(0, -10, 0),

                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 40,
                                offset: const Offset(0, 40))
                          ]),
                      child: OnBoardingView(
                        closeModal: () {
                          _showOnBoarding(false);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          IgnorePointer(
            ignoring: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                // margin: EdgeInsets.symmetric(horizontal: 24),
                // padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(colors: [
                    RiveAppTheme.background.withOpacity(0),
                    RiveAppTheme.background.withOpacity(1 -
                        ((!showOnBoarding
                                ? _sidebarAnim.value
                                : _onBoardingAnim.value) *
                            1))
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                // child: SizedBox(height: 150),
              ),
            ),
          ),
        ],
        // )
        // },
      ),
      bottomNavigationBar: /*AnimatedBuilder(
        animation: animationController!,
        builder: (context, child) {
          return*/
          Transform.translate(
        offset: Offset(
            0,
            !showOnBoarding
                ? _sidebarAnim!.value * 300
                : _onBoardingAnim.value * 200),
        child: /*Visibility(
              visible: !showOnBoarding,
              maintainAnimation: true,
              maintainState: true,
              maintainSize: true,
              child:*/
            CustomTabBar(
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
