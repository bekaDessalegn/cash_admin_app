import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarLogo extends StatelessWidget {
  const AppBarLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.go('/');
      },
      child: Image.asset(
        "images/cash_logo.png",
        width: 120,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }
}
