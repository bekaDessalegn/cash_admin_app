import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/login/presentation/widgets/mobile_login_body.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: SafeArea(child: SingleChildScrollView(child: MobileLoginBody())),
    );
  }
}
