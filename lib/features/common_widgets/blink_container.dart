import 'dart:async';

import 'package:flutter/material.dart';

class BlinkContainer extends StatefulWidget {
  double width, height;
  BlinkContainer({required this.width, required this.height});

  @override
  State<BlinkContainer> createState() => _BlinkContainerState();
}

class _BlinkContainerState extends State<BlinkContainer> {

  bool _show = true;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _show = !_show;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _show ? Container(
      color: Colors.white70,
      height: widget.height,
      width: widget.width,
    ) : Container(
      color: Colors.grey,
      height: widget.height,
      width: widget.width,
    );
  }
}
