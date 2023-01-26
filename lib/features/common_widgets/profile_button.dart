import 'package:cash_admin_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:cash_admin_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/ph.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
        iconSize: 28,
        onPressed: () {
          context.push("/profile");
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        },
        icon: Iconify(
          Ph.user,
          size: 28,
        ));
  }
}
