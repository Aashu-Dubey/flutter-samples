import 'dart:math';
import 'package:flutter/material.dart';

class PassValidity {
  PassValidity(
      {this.lowercase = false,
      this.uppercase = false,
      this.numeric = false,
      this.specialChar = false,
      this.minChar = false});

  bool lowercase;
  bool uppercase;
  bool numeric;
  bool specialChar;
  bool minChar;
}

var passColors = [
  Colors.grey.shade400,
  Colors.red,
  Colors.orange,
  Colors.blueGrey,
  Colors.green,
  Colors.blueAccent,
];

class PasswordStrength extends StatefulWidget {
  final TextEditingController? inputController;
  final int maxLength;

  const PasswordStrength({this.inputController, this.maxLength = 8, super.key});

  @override
  State<PasswordStrength> createState() => _PasswordStrengthState();
}

class _PasswordStrengthState extends State<PasswordStrength>
    with TickerProviderStateMixin {
  late AnimationController _cursorAnimController;
  late AnimationController _inputTransXController;
  late AnimationController _tickAnim;

  late TextEditingController _inputController;
  final _passCloneController = TextEditingController();
  final _passFocusNode = FocusNode();
  var _passwordStrength = 0;
  PassValidity _passwordValidity = PassValidity();

  var inputKey = GlobalKey();
  var inputCloneKey = GlobalKey();
  Size inputSize = const Size(0, 0);

  updateCursorPosition({rerender = false}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Get sizes for input and it's clone
      var inputBox = inputKey.currentContext?.findRenderObject() as RenderBox;
      var inputCloneBox =
          inputCloneKey.currentContext?.findRenderObject() as RenderBox;

      inputSize = inputCloneBox.size;

      // Set custom cursor position to active position, but should exceed the input area
      var transX =
          min(inputCloneBox.size.width - 3, inputBox.constraints.maxWidth - 24);
      // Translate to the right end if not focused except if it is empty
      if (!_passFocusNode.hasFocus && _inputController.text.isNotEmpty) {
        transX = (inputBox.size.width - 24) - (inputCloneBox.size.height);
      }
      _inputTransXController
          .animateTo(transX, duration: const Duration(milliseconds: 200))
          .then((value) {
        // Animation the tick after cursor -> circle
        if (!_passFocusNode.hasFocus) {
          if (_tickAnim.value != 1) {
            _tickAnim.animateTo(1);
          }
        } else if (_tickAnim.value != 0) {
          _tickAnim.animateTo(0);
        }
      });

      // Need to setstate initially here, otherwise won't show blinking cursor on first intialization
      if (rerender) {
        setState(() {});
      }
    });
  }

  checkpasswordStrength() {
    var value = _inputController.text;
    var strength = 0;
    var validity = PassValidity();
    if (value.length >= 8) {
      strength += 1;
      validity.minChar = true;
    }
    if (RegExp(r'[a-z]+').hasMatch(value)) {
      strength += 1;
      validity.lowercase = true;
    }
    if (RegExp(r'[A-Z]+').hasMatch(value)) {
      strength += 1;
      validity.uppercase = true;
    }
    if (RegExp(r'[0-9]+').hasMatch(value)) {
      strength += 1;
      validity.numeric = true;
    }
    if (RegExp(r'[$@#&!]+').hasMatch(value)) {
      strength += 1;
      validity.specialChar = true;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordValidity = validity;
    });
  }

  getErrText(String title, bool valid) {
    var color = _passFocusNode.hasFocus || _inputController.text.isEmpty
        ? Colors.grey
        : valid
            ? Colors.blueAccent
            : Colors.red;

    return TextSpan(
        text: title,
        style: TextStyle(color: color, fontWeight: FontWeight.w600));
  }

  @override
  void initState() {
    super.initState();
    _inputController = widget.inputController ?? TextEditingController();

    _cursorAnimController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _cursorAnimController.repeat(reverse: true);

    _tickAnim = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _inputTransXController = AnimationController.unbounded(vsync: this);

    _passFocusNode.addListener(() {
      if (!_passFocusNode.hasFocus) {
        _cursorAnimController.stop();
        _cursorAnimController.value = 1;
      } else {
        _cursorAnimController.repeat(reverse: true);
      }
      checkpasswordStrength();
    });

    _inputController.addListener(() {
      // Set the input clone's text till the cursor position only, so we can get accurate position to simulate
      _passCloneController.value = TextEditingValue(
        text: _inputController.text
            .substring(0, _inputController.selection.base.offset),
      );
      checkpasswordStrength();
    });

    updateCursorPosition(rerender: true);
  }

  @override
  void dispose() {
    _cursorAnimController.dispose();
    _inputTransXController.dispose();
    _tickAnim.dispose();
    _inputController.dispose();
    _passCloneController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateCursorPosition();
    var fillPercent = (_inputController.text.length / widget.maxLength) * 100;
    var caretFillHeight = (fillPercent / 100) * inputSize.height;

    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Password",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${_inputController.text.length}/${widget.maxLength}",
                  style: TextStyle(color: Colors.grey.shade400),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              TextField(
                key: inputKey,
                showCursor: false,
                obscureText: true,
                controller: _inputController,
                focusNode: _passFocusNode,
                decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    contentPadding: const EdgeInsets.all(12)),
              ),
              if (_passFocusNode.hasFocus || _inputController.text.isNotEmpty)
                AnimatedBuilder(
                  animation: _inputTransXController,
                  builder: (context, child) {
                    return Transform.translate(
                        offset: Offset(_inputTransXController.value, 0),
                        child: child);
                  },
                  child: FadeTransition(
                    opacity: _cursorAnimController.view,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: !_passFocusNode.hasFocus
                            ? inputSize.height
                            : _passCloneController.text.length <
                                    _inputController.text.length
                                ? 2
                                : 4,
                        height: inputSize.height,
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade400,
                        ),
                        child: Container(
                          height: !_passFocusNode.hasFocus
                              ? inputSize.height
                              : caretFillHeight,
                          constraints: const BoxConstraints.tightFor(
                              width: double.infinity),
                          decoration: BoxDecoration(
                              color: !_passFocusNode.hasFocus
                                  ? _passwordStrength < 5
                                      ? Colors.red
                                      : Colors.blueAccent
                                  : passColors[_passwordStrength]),
                          child: AnimatedBuilder(
                            animation: _tickAnim,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _tickAnim.value,
                                child: child,
                              );
                            },
                            child: Icon(
                              _passwordStrength < 5
                                  ? Icons.close
                                  : Icons.check_rounded,
                              color: Colors.white,
                              size: inputSize.height - 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              children: [
                const TextSpan(text: "Password must contain at least "),
                getErrText("one small", _passwordValidity.lowercase),
                const TextSpan(text: " & "),
                getErrText("one capital", _passwordValidity.uppercase),
                const TextSpan(text: " alphabet, "),
                getErrText("one numeric digit", _passwordValidity.numeric),
                const TextSpan(text: ", "),
                getErrText(
                    "one special character", _passwordValidity.specialChar),
                const TextSpan(text: " and be at least "),
                getErrText("${widget.maxLength} characters long",
                    _passwordValidity.minChar),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(12)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
                backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
                splashFactory: InkSparkle.splashFactory,
                overlayColor: MaterialStatePropertyAll(Colors.lightBlue)),
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _passFocusNode.unfocus();
            },
          )
        ],
      ),
      IgnorePointer(
        child: Opacity(
          opacity: 0,
          child: IntrinsicWidth(
            child: TextField(
              key: inputCloneKey,
              controller: _passCloneController,
              obscureText: true,
              decoration: const InputDecoration(
                  isDense: true, contentPadding: EdgeInsets.zero),
            ),
          ),
        ),
      )
    ]);
  }
}
