import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/profile/presentation/widgets/profile_body.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: SafeArea(child: ProfileBody()),
    );
  }
}
