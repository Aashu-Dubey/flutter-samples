import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Factory;
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_samples/samples/ui/rive_app/theme.dart';
import 'package:flutter_samples/samples/ui/rive_app/assets.dart' as app_assets;

class SignInView extends StatefulWidget {
  const SignInView({super.key, this.closeModal});

  final Function? closeModal;

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  late final checkFileLoader = FileLoader.fromAsset(
    app_assets.checkRiv,
    riveFactory: Factory.rive,
  );
  late final confettiFileLoader = FileLoader.fromAsset(
    app_assets.confettiRiv,
    riveFactory: Factory.rive,
  );

  TriggerInput? _successAnim;
  TriggerInput? _errorAnim;
  TriggerInput? _resetAnim;
  TriggerInput? _confettiAnim;

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();

    checkFileLoader.dispose();
    confettiFileLoader.dispose();
    _successAnim?.dispose();
    _errorAnim?.dispose();
    _resetAnim?.dispose();
    _confettiAnim?.dispose();
    super.dispose();
  }

  void _onCheckRiveInit(RiveWidgetController controller) {
    _successAnim = controller.stateMachine.trigger("Check");
    _errorAnim = controller.stateMachine.trigger("Error");
    _resetAnim = controller.stateMachine.trigger("Reset");
  }

  void _onConfettiRiveInit(RiveWidgetController controller) {
    _confettiAnim = controller.stateMachine.trigger("Trigger explosion");
  }

  void login() {
    setState(() {
      _isLoading = true;
    });

    bool isEmailValid = _emailController.text.trim().isNotEmpty;
    bool isPassValid = _passController.text.trim().isNotEmpty;
    bool isValid = isEmailValid && isPassValid;

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      isValid ? _successAnim?.fire() : _errorAnim?.fire();
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      _resetAnim?.fire();
      setState(() {
        _isLoading = false;
      });
      if (isValid) _confettiAnim?.fire();
    });

    if (isValid) {
      Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
        widget.closeModal!();
        _emailController.text = "";
        _passController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.white.withValues(alpha: 0.8), Colors.white10],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(29),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: RiveAppTheme.shadow.withValues(alpha: 0.3),
                              offset: const Offset(0, 3),
                              blurRadius: 5),
                          BoxShadow(
                              color: RiveAppTheme.shadow.withValues(alpha: 0.3),
                              offset: const Offset(0, 30),
                              blurRadius: 30)
                        ],
                        color: CupertinoColors.secondarySystemBackground,
                        // This kind of give the background iOS style "Frosted Glass" effect,
                        // it works for this particular color, might not for other
                        backgroundBlendMode: BlendMode.luminosity),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Sign In",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 34),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                            "Access to 240+ hours of content. Learn design and code, by building real apps with React and Swift.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 17,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: TextStyle(
                                color: CupertinoColors.secondaryLabel,
                                fontFamily: "Inter",
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: authInputStyle("icon_email"),
                          controller: _emailController,
                        ),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style: TextStyle(
                                color: CupertinoColors.secondaryLabel,
                                fontFamily: "Inter",
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          obscureText: true,
                          decoration: authInputStyle("icon_lock"),
                          controller: _passController,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF77D8E).withValues(alpha: 0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(20),
                            color: const Color(0xFFF77D8E),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.arrow_forward_rounded),
                                SizedBox(width: 4),
                                Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            onPressed: () {
                              if (!_isLoading) login();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      fontSize: 15,
                                      fontFamily: "Inter"),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                        ),
                        const Text("Sign up with Email, Apple or Google",
                            style: TextStyle(
                                color: CupertinoColors.secondaryLabel,
                                fontFamily: "Inter",
                                fontSize: 15)),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(app_assets.logoEmail),
                            Image.asset(app_assets.logoApple),
                            Image.asset(app_assets.logoGoogle)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: RivePanel(
                      // One screen-density surface for both graphics. The 3x transform on the
                      // confetti is applied while drawing, so it stays sharp without layout(scale: 3).
                      renderResolution: .layout(),
                      child: Stack(
                        children: [
                          if (_isLoading)
                            // Because of parent RivePanel, direct alignment property on Stack isn't respected
                            Center(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: RiveWidgetBuilder(
                                  fileLoader: checkFileLoader,
                                  onLoaded: (state) =>
                                      _onCheckRiveInit(state.controller),
                                  builder: (context, state) {
                                    if (state is RiveLoaded) {
                                      return RiveWidget(
                                        controller: state.controller,
                                        useSharedTexture: true,
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
                          Positioned.fill(
                            child: SizedBox(
                              width: 500,
                              height: 500,
                              child: Transform.scale(
                                scale: 3,
                                child: RiveWidgetBuilder(
                                  fileLoader: confettiFileLoader,
                                  onLoaded: (state) =>
                                      _onConfettiRiveInit(state.controller),
                                  builder: (context, state) {
                                    if (state is RiveLoaded) {
                                      return RiveWidget(
                                        controller: state.controller,
                                        useSharedTexture: true,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(36 / 2),
                      minimumSize: Size(36, 36),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(36 / 2),
                          boxShadow: [
                            BoxShadow(
                              color: RiveAppTheme.shadow.withValues(alpha: 0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        widget.closeModal!();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Common style for Auth Input fields email and password
InputDecoration authInputStyle(String iconName) {
  return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1))),
      contentPadding: const EdgeInsets.all(15),
      prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Image.asset("assets/samples/ui/rive_app/images/$iconName.png")));
}
