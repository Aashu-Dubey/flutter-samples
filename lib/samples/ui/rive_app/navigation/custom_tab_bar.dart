import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter_samples/samples/ui/rive_app/models/tab_item.dart';
import 'package:flutter_samples/samples/ui/rive_app/theme.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key, required this.onTabChange, required this.fileLoader});

  final Function(int tabIndex) onTabChange;
  final rive.FileLoader fileLoader;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final List<TabItem> _icons = TabItem.tabItemsList;

  int _selectedTab = 0;

  void _onRiveIconInit(rive.RiveWidgetController controller, index) {
    _icons[index].status = controller.stateMachine.boolean("active");
  }

  void onTabPress(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      widget.onTabChange(index);

      _icons[index].status?.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        _icons[index].status?.value = false;
      });
    }
  }

  @override
  void dispose() {
    for (var icon in _icons) {
      icon.status?.dispose();
      icon.status = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        padding: const EdgeInsets.all(1),
        constraints: const BoxConstraints(maxWidth: 768),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: [
            Colors.white.withValues(alpha: 0.5),
            Colors.white.withValues(alpha: 0)
          ]),
        ),
        child: Container(
          // Clip to avoid the tab touch outside the border radius area
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: RiveAppTheme.background2.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: RiveAppTheme.background2.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              TabItem icon = _icons[index];

              return Expanded(
                key: icon.id,
                child: CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  child: AnimatedOpacity(
                    opacity: _selectedTab == index ? 1 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -4,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 4,
                              width: _selectedTab == index ? 20 : 0,
                              decoration: BoxDecoration(
                                color: RiveAppTheme.accentColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 36,
                            width: 36,
                            child: rive.RiveWidgetBuilder(
                              fileLoader: widget.fileLoader,
                              stateMachineSelector: rive.StateMachineSelector.byName(
                                icon.stateMachine,
                              ),
                              artboardSelector: rive.ArtboardSelector.byName(
                                icon.artboard,
                              ),
                              onLoaded: (state) =>
                                  _onRiveIconInit(state.controller, index),
                              builder: (context, state) {
                                if (state is rive.RiveLoaded) {
                                  return rive.RiveWidget(
                                    controller: state.controller,
                                    // Added for consistency with the SideMenu icons
                                    renderResolution: .layout(),
                                    hitTestBehavior: .none,
                                  );
                                }
                                if (state is rive.RiveFailed && kDebugMode) {
                                  debugPrint('Rive failed: ${state.error}');
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          )
                        ]),
                  ),
                  onPressed: () {
                    onTabPress(index);
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
