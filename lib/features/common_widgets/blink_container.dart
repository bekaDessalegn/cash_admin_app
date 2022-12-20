import 'dart:async';

import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

class BlinkContainer extends StatefulWidget {
  double width, height, borderRadius;
  BlinkContainer({required this.width, required this.height, required this.borderRadius});

  @override
  State<BlinkContainer> createState() => _BlinkContainerState();
}

class _BlinkContainerState extends State<BlinkContainer> {

  bool _show = true;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 600), (timer) {
      setState(() {
        _show = !_show;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _show ? Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          color: surfaceColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(widget.borderRadius)
      ),
    ) : Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(widget.borderRadius)
      ),
    );
  }
}
