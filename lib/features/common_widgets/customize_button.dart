import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

class CustomizeButton extends StatelessWidget {
  const CustomizeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
        iconSize: 30,
        onPressed: () {
          context.push(APP_PAGE.customize.toPath);
        },
        icon: Iconify(
          Bx.edit,
          size: 30,
        ));
  }
}