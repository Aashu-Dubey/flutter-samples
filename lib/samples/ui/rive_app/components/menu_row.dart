import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_samples/samples/ui/rive_app/models/menu_item.dart';

class MenuRow extends StatefulWidget {
  const MenuRow({
    super.key,
    required this.menu,
    required this.fileLoader,
    this.selectedMenu = "Home",
    this.onMenuPress,
  });

  final MenuItemModel menu;
  final String selectedMenu;
  final Function? onMenuPress;
  final FileLoader fileLoader;

  @override
  State<MenuRow> createState() => _MenuRow();
}

class _MenuRow extends State<MenuRow> {
  void _onMenuIconInit(RiveWidgetController controller) {
    widget.menu.riveIcon.status = controller.stateMachine.boolean("active");
  }

  void onMenuPressed() {
    if (widget.selectedMenu != widget.menu.title) {
      widget.onMenuPress!();
      widget.menu.riveIcon.status?.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        widget.menu.riveIcon.status?.value = false;
      });
    }
  }

  @override
  void dispose() {
    widget.menu.riveIcon.status?.dispose();
    widget.menu.riveIcon.status = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The menu button background that animates as we click on it
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.selectedMenu == widget.menu.title ? 288 - 16 : 0,
          height: 56,
          curve: const Cubic(0.2, 0.8, 0.2, 1),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        CupertinoButton(
          padding: const EdgeInsets.all(12),
          pressedOpacity: 1, // disable touch effect
          onPressed: onMenuPressed,
          child: Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: Opacity(
                  opacity: 0.6,
                  child: RiveWidgetBuilder(
                    fileLoader: widget.fileLoader,
                    stateMachineSelector: StateMachineSelector.byName(
                      widget.menu.riveIcon.stateMachine,
                    ),
                    artboardSelector: ArtboardSelector.byName(
                      widget.menu.riveIcon.artboard,
                    ),
                    onLoaded: (state) => _onMenuIconInit(state.controller),
                    builder: (context, state) {
                      if (state is RiveLoaded) {
                        return RiveWidget(controller: state.controller);
                      }
                      if (state is RiveFailed && kDebugMode) {
                        debugPrint('Rive failed: ${state.error}');
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                widget.menu.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
