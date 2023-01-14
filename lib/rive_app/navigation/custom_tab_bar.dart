import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:flutter_samples/rive_app/models/tab_item.dart';
import 'package:flutter_samples/rive_app/theme.dart';
import 'package:flutter_samples/rive_app/assets.dart' as app_assets;

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({Key? key, required this.onTabChange}) : super(key: key);

  final Function(int tabIndex) onTabChange;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final List<TabItem> _icons = TabItem.tabItemsList;

  // late RiveAnimationController _chatIconController;

  // late List<SMIBool?> iconControllers = List.filled(icons.length, null);
  int selectedTab = 0;

  void _onRiveIconInit(Artboard artboard, index) {
    final controller = StateMachineController.fromArtboard(
        artboard, _icons[index].stateMachine);
    artboard.addController(controller!);
    /*controller.isActiveChanged.addListener(() {
      if (controller.isActive) {
        Future.delayed(const Duration(seconds: 2), () {
          controller.isActive = false;
        });
      }
    });*/
    // controller.isActive = true;
    // iconControllers[index] = controller;
    _icons[index].status = controller.findInput<bool>("active") as SMIBool;
  }

  @override
  void initState() {
    /*_chatIconController = SimpleAnimation("active", autoplay: false);
    _chatIconController.isActiveChanged.addListener(() {
      if (_chatIconController.isActive) {
        Future.delayed(const Duration(seconds: 2), () {
          _chatIconController.isActive = false;
        });
      }
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: Align(
      //   alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0)
          ]),
        ),
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          // Clip to avoid the tab touch outside the border radius area
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: RiveAppTheme.background2.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: RiveAppTheme.background2.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _icons.length,
              (index) {
                TabItem icon = _icons[index];

                return Expanded(
                  key: icon.id,
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(12),
                    child: AnimatedOpacity(
                      opacity: selectedTab == index ? 1 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // if (selectedTab == index)
                          Positioned(
                            top: -4,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 4,
                              width: selectedTab == index ? 20 : 0,
                              decoration: BoxDecoration(
                                color: RiveAppTheme.accentColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 36,
                            // width: 36,
                            child: RiveAnimation.asset(
                              app_assets.iconsRiv,
                              stateMachines: [icon.stateMachine],
                              artboard: icon.artboard,
                              // fit: BoxFit.cover,
                              // controllers: [_chatIconController],
                              onInit: (artboard) {
                                _onRiveIconInit(artboard, index);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      if (selectedTab != index) {
                        // _chatIconController.isActive = true;
                        setState(() {
                          selectedTab = index;
                        });
                        widget.onTabChange(index);

                        // Some issue where if we setState animation is not playing, so just setting a minor delay
                        // Future.delayed(const Duration(milliseconds: 50), () {
                        _icons[index].status!.change(true);
                        Future.delayed(const Duration(seconds: 1), () {
                          _icons[index].status!.change(false);
                        });
                        // });
                      }
                    },
                  ),
                );
              },
            ),
            // children: [
            //   CupertinoButton(
            //     child: RiveAnimation.asset(
            //       'assets/rive/icons.riv',
            //       stateMachines: ["CHAT_Interactivity"],
            //       artboard: "CHAT",
            //       // fit: BoxFit.cover,
            //       controllers: [_chatIconController],
            //     ),
            //     onPressed: () {
            //       _chatIconController.isActive = true;
            //     },
            //   ),
            // ],
          ),
        ),
      ),
      // ),
    );
  }
}
