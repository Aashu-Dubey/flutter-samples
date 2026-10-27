import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_samples/samples/ui/rive_app/components/menu_row.dart';
import 'package:flutter_samples/samples/ui/rive_app/models/menu_item.dart';
import 'package:flutter_samples/samples/ui/rive_app/theme.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.fileLoader});

  final FileLoader fileLoader;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final List<MenuItemModel> _browseMenuIcons = MenuItemModel.menuItems;
  final List<MenuItemModel> _historyMenuIcons = MenuItemModel.menuItems2;
  final List<MenuItemModel> _themeMenuIcon = MenuItemModel.menuItems3;
  String _selectedMenu = MenuItemModel.menuItems[0].title;
  bool _isDarkMode = false;

  void onThemeRiveIconInit(RiveWidgetController controller) {
    _themeMenuIcon[0].riveIcon.status = controller.stateMachine.boolean("active");
  }

  void onMenuPress(MenuItemModel menu) {
    setState(() {
      _selectedMenu = menu.title;
    });
  }

  void onThemeToggle(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _themeMenuIcon[0].riveIcon.status?.value = value;
  }

  @override
  void dispose() {
    _themeMenuIcon[0].riveIcon.status?.dispose();
    _themeMenuIcon[0].riveIcon.status = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom - 60),
      constraints: const BoxConstraints(maxWidth: 288),
      decoration: BoxDecoration(
        color: RiveAppTheme.background2,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.person_outline),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ashu",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: "Inter"),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Software Engineer",
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 15,
                          fontFamily: "Inter"),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MenuButtonSection(
                      title: "BROWSE",
                      selectedMenu: _selectedMenu,
                      menuIcons: _browseMenuIcons,
                      fileLoader: widget.fileLoader,
                      onMenuPress: onMenuPress),
                  MenuButtonSection(
                      title: "HISTORY",
                      selectedMenu: _selectedMenu,
                      menuIcons: _historyMenuIcons,
                      fileLoader: widget.fileLoader,
                      onMenuPress: onMenuPress),
                ],
              ),
            ),
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              SizedBox(
                width: 32,
                height: 32,
                child: Opacity(
                  opacity: 0.6,
                  child: RiveWidgetBuilder(
                    fileLoader: widget.fileLoader,
                    stateMachineSelector: StateMachineSelector.byName(
                      _themeMenuIcon[0].riveIcon.stateMachine,
                    ),
                    artboardSelector: ArtboardSelector.byName(
                      _themeMenuIcon[0].riveIcon.artboard,
                    ),
                    onLoaded: (state) =>
                        onThemeRiveIconInit(state.controller),
                    builder: (context, state) {
                      if (state is RiveLoaded) {
                        return RiveWidget(
                          controller: state.controller,
                          // Same reason as the MenuRow icons: this icon sits in
                          // the rotateY-animated drawer, so a fixed texture size
                          // avoids the first-open reallocation and flicker on Android.
                          renderResolution: .layout(),
                          hitTestBehavior: .none,
                        );
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
              Expanded(
                child: Text(
                  _themeMenuIcon[0].title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600),
                ),
              ),
              CupertinoSwitch(value: _isDarkMode, onChanged: onThemeToggle),
            ]),
          )
        ],
      ),
    );
  }
}

class MenuButtonSection extends StatelessWidget {
  const MenuButtonSection(
      {super.key,
      required this.title,
      required this.menuIcons,
      required this.fileLoader,
      this.selectedMenu = "Home",
      this.onMenuPress});

  final String title;
  final String selectedMenu;
  final List<MenuItemModel> menuIcons;
  final FileLoader fileLoader;
  final Function(MenuItemModel menu)? onMenuPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 15,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var menu in menuIcons) ...[
                Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    thickness: 1,
                    height: 1,
                    indent: 16,
                    endIndent: 16),
                MenuRow(
                  menu: menu,
                  selectedMenu: selectedMenu,
                  fileLoader: fileLoader,
                  onMenuPress: () => onMenuPress!(menu),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
