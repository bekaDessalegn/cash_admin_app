import 'package:cash_admin_app/features/common_widgets/app_bar_logo.dart';
import 'package:cash_admin_app/features/common_widgets/profile_button.dart';
import 'package:flutter/material.dart';

final appbar = PreferredSize(
  preferredSize: Size.fromHeight(kToolbarHeight),
  child: Container(
    height: 80,
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: Offset(0, 1.0),
        blurRadius: 7.0,
      )
    ], color: Colors.white),
    child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        actions: [
          ProfileButton(),
        ],
        title: AppBarLogo()
    ),
  ),
);