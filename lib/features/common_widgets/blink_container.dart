import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

class BlinkContainer extends StatefulWidget {
  double width, height, borderRadius;
  BlinkContainer({required this.width, required this.height, required this.borderRadius});

  @override
  State<BlinkContainer> createState() => _BlinkContainerState();
}

class _BlinkContainerState extends State<BlinkContainer> with TickerProviderStateMixin{

  late AnimationController _colorAnimationController;
  late Animation _containerAnimationColor;

  @override
  void initState() {
    _colorAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600)
    );

    _containerAnimationColor = ColorTween(
        begin: surfaceColor.withOpacity(0.4),
        end: surfaceColor
    ).animate(_colorAnimationController)..addListener(() {
      setState(() {

      });
    })..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _colorAnimationController.reverse();
      } else if(status == AnimationStatus.dismissed){
        _colorAnimationController.forward();
      }
    });

    _colorAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          color: _containerAnimationColor.value,
        borderRadius: BorderRadius.circular(widget.borderRadius)
      ),
    );
  }
}
