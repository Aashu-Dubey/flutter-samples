import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'dart:math' as math;
import 'package:flutter_samples/samples/ui/rive_app/navigation/custom_tab_bar.dart';
import 'package:flutter_samples/samples/ui/rive_app/navigation/home_tab_view.dart';
import 'package:flutter_samples/samples/ui/rive_app/on_boarding/onboarding_view.dart';
import 'package:flutter_samples/samples/ui/rive_app/navigation/side_menu.dart';
import 'package:flutter_samples/samples/ui/rive_app/theme.dart';
import 'package:flutter_samples/samples/ui/rive_app/assets.dart' as app_assets;

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
  const RiveAppHome({super.key});

  static const String route = '/course-rive';

  @override
  State<RiveAppHome> createState() => _RiveAppHomeState();
}

class _RiveAppHomeState extends State<RiveAppHome>
    with TickerProviderStateMixin {
  late AnimationController? _animationController;
  late AnimationController? _onBoardingAnimController;
  late Animation<double> _onBoardingAnim;
  late Animation<double> _sidebarAnim;

  // These 12 icons are Flutter UI (tab bar and side menu), not content
  // graphics: they only need Flutter opacity/transforms and no
  // Rive-renderer-specific features. Each Factory.rive widget owns a render
  // texture, which is a WebGL context on web (browsers cap those at ~16), so
  // paint these with the Flutter renderer on web. On the other platforms the
  // Rive renderer already works and there is no context limit, so keep it.
  late final iconsFileLoader = rive.FileLoader.fromAsset(
    app_assets.iconsRiv,
    riveFactory: kIsWeb ? rive.Factory.flutter : rive.Factory.rive,
  );
  late final menuBtnFileLoader = rive.FileLoader.fromAsset(app_assets.menuButtonRiv, riveFactory: rive.Factory.rive);
  rive.BooleanInput? _menuBtn;

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

  void _onMenuIconInit(rive.RiveWidgetController controller) {
    _menuBtn = controller.stateMachine.boolean('isOpen');
    _menuBtn?.value = true;
  }

  void _presentOnBoarding(bool show) {
    if (show) {
      setState(() {
        _showOnBoarding = true;
      });
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _onBoardingAnimController?.animateWith(springAnim);
    } else {
      _onBoardingAnimController?.reverse().whenComplete(() => {
            setState(() {
              _showOnBoarding = false;
            })
          });
    }
  }

  void onMenuPress() {
    if (_menuBtn == null) return;

    if (_menuBtn?.value == true) {
      final springAnim = SpringSimulation(springDesc, 0, 1, 0);
      _animationController?.animateWith(springAnim);
    } else {
      _animationController?.reverse();
    }
    _menuBtn?.value = !_menuBtn!.value;

    SystemChrome.setSystemUIOverlayStyle(_menuBtn!.value
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light);
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      upperBound: 1,
      vsync: this,
    );
    _onBoardingAnimController = AnimationController(
      duration: const Duration(milliseconds: 350),
      upperBound: 1,
      vsync: this,
    );

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
    _menuBtn?.dispose();
    menuBtnFileLoader.dispose();
    iconsFileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned(child: Container(color: RiveAppTheme.background2)),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(((1 - _sidebarAnim.value) * -30) * math.pi / 180)
                    ..translateByDouble(
                      (1 - _sidebarAnim.value) * -300,
                      0.0,
                      0.0,
                      1.0,
                    ),
                  child: child,
                );
              },
              child: FadeTransition(
                opacity: _sidebarAnim,
                child: SideMenu(fileLoader: iconsFileLoader),
              ),
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _showOnBoarding ? _onBoardingAnim : _sidebarAnim,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 -
                      (_showOnBoarding
                          ? _onBoardingAnim.value * 0.08
                          : _sidebarAnim.value * 0.1),
                  child: Transform.translate(
                    offset: Offset(_sidebarAnim.value * 265, 0),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY((_sidebarAnim.value * 30) * math.pi / 180),
                      child: child,
                    ),
                  ),
                );
              },
              child: _tabBody,
            ),
          ),
          AnimatedBuilder(
            animation: _sidebarAnim,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                right: (_sidebarAnim.value * -100) + 16,
                child: child!,
              );
            },
            child: GestureDetector(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: RiveAppTheme.shadow.withValues(alpha: 0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Icon(Icons.person_outline),
                ),
              ),
              onTap: () {
                _presentOnBoarding(true);
              },
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _sidebarAnim,
              builder: (context, child) {
                return SafeArea(
                  child: Row(
                    children: [
                      // There's an issue/behaviour in flutter where translating the GestureDetector or any button
                      // doesn't translate the touch area, making the Widget unclickable, so instead setting a SizedBox
                      // in a Row to have a similar effect
                      SizedBox(width: _sidebarAnim.value * 216),
                      child!,
                    ],
                  ),
                );
              },
              child: GestureDetector(
                onTap: onMenuPress,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(44 / 2),
                      boxShadow: [
                        BoxShadow(
                          color: RiveAppTheme.shadow.withValues(alpha: 0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: rive.RiveWidgetBuilder(
                      fileLoader: menuBtnFileLoader,
                      onLoaded: (state) => _onMenuIconInit(state.controller),
                      builder: (context, state) {
                        if (state is rive.RiveLoaded) {
                          return rive.RiveWidget(controller: state.controller);
                        }
                        if (state is rive.RiveFailed && kDebugMode) {
                          debugPrint('Rive failed: ${state.error}');
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_showOnBoarding)
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _onBoardingAnim,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        0,
                        -(MediaQuery.of(context).size.height +
                                MediaQuery.of(context).padding.bottom) *
                            (1 - _onBoardingAnim.value)),
                    child: child!,
                  );
                },
                child: SafeArea(
                  top: false,
                  maintainBottomViewPadding: true,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
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
            ),
          // White underlay behind the bottom tab bar
          IgnorePointer(
            ignoring: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                  animation: !_showOnBoarding ? _sidebarAnim : _onBoardingAnim,
                  builder: (context, child) {
                    return Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            RiveAppTheme.background.withValues(alpha: 0),
                            RiveAppTheme.background.withValues(alpha: 1 -
                                (!_showOnBoarding
                                    ? _sidebarAnim.value
                                    : _onBoardingAnim.value))
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: RepaintBoundary(
        child: AnimatedBuilder(
          animation: !_showOnBoarding ? _sidebarAnim : _onBoardingAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                  0,
                  !_showOnBoarding
                      ? _sidebarAnim.value * 300
                      : _onBoardingAnim.value * 200),
              child: child,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomTabBar(
                fileLoader: iconsFileLoader,
                onTabChange: (tabIndex) {
                  setState(() {
                    _tabBody = _screens[tabIndex];
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
