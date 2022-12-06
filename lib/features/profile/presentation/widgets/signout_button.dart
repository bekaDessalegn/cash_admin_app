import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/profile/presentation/widgets/signout_dialog.dart';
import 'package:flutter/material.dart';

Widget signoutButton(BuildContext context) {
  return GestureDetector(
    onTap: (){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return signoutDialog(
                context: context
            );
          });
    },
    child: normalText(value: "Sign out", size: 17, color: linkColor),
  );
}
