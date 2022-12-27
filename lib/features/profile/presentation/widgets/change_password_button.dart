import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget changePasswordButton({required BuildContext context}){
  return GestureDetector(
    onTap: (){
      context.push('/edit_profile');
    },
    child: normalText(value: "Change password", size: 17, color: linkColor),
  );
}