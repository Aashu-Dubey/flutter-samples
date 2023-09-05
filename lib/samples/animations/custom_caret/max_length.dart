import 'dart:math';
import 'package:flutter/material.dart';

class CaretMaxLength extends StatefulWidget {
  final TextEditingController? inputController;
  final int maxLength;

  const CaretMaxLength({this.inputController, this.maxLength = 8, super.key});

  @override
  State<CaretMaxLength> createState() => _CaretMaxLengthState();
}

class _CaretMaxLengthState extends State<CaretMaxLength>
    with TickerProviderStateMixin {
  late AnimationController _cursorAnimController;
  late AnimationController _inputTransXController;
  late AnimationController _tickAnim;

  late TextEditingController _inputController;
  final _nameCloneController = TextEditingController();
  final _nameFocusNode = FocusNode();

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
      // Translate to the right end if reaches the max length
      if (_inputController.text.length == widget.maxLength) {
        transX = (inputBox.size.width - 24) - (inputCloneBox.size.height);
      }
      _inputTransXController
          .animateTo(transX, duration: const Duration(milliseconds: 200))
          .then((value) {
        // Animation the tick after cursor -> circle
        if (_inputController.text.length == widget.maxLength) {
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

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _cursorAnimController.stop();
        _cursorAnimController.value = 1;
      } else if (_inputController.text.length < widget.maxLength) {
        _cursorAnimController.repeat(reverse: true);
      }
      setState(() {});
    });

    _inputController.addListener(() {
      if (_inputController.text.length == widget.maxLength) {
        _cursorAnimController.stop();
        _cursorAnimController.value = 1;
      } else {
        _cursorAnimController.repeat(reverse: true);
      }

      // Set the input clone's text till the cursor position only, so we can get accurate position to simulate
      _nameCloneController.value = TextEditingValue(
        text: _inputController.text
            .substring(0, _inputController.selection.base.offset),
      );
      setState(() {});
    });

    updateCursorPosition(rerender: true);
  }

  @override
  void dispose() {
    _cursorAnimController.dispose();
    _inputTransXController.dispose();
    _tickAnim.dispose();
    _inputController.dispose();
    _nameCloneController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateCursorPosition();
    var inputTextLength = _inputController.text.length;
    var fillPercent = (inputTextLength / widget.maxLength) * 100;
    var caretFillHeight = (fillPercent / 100) * inputSize.height;

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Username",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "$inputTextLength/${widget.maxLength}",
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
                  maxLength: widget.maxLength,
                  controller: _inputController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(
                      isDense: true,
                      fillColor: Colors.white,
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      contentPadding: const EdgeInsets.all(12)),
                ),
                if (_nameFocusNode.hasFocus ||
                    inputTextLength == widget.maxLength)
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
                          width: inputTextLength == widget.maxLength
                              ? inputSize.height
                              : _nameCloneController.text.length <
                                      (inputTextLength)
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
                            height: caretFillHeight,
                            constraints: const BoxConstraints.tightFor(
                                width: double.infinity),
                            decoration:
                                const BoxDecoration(color: Colors.blueAccent),
                            child: AnimatedBuilder(
                              animation: _tickAnim,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _tickAnim.value,
                                  child: child,
                                );
                              },
                              child: Icon(
                                Icons.check_rounded,
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
          ],
        ),
        IgnorePointer(
          child: Opacity(
            opacity: 0,
            child: IntrinsicWidth(
              child: TextField(
                key: inputCloneKey,
                controller: _nameCloneController,
                decoration: const InputDecoration(
                    isDense: true, contentPadding: EdgeInsets.zero),
              ),
            ),
          ),
        )
      ],
    );
  }
}
