import 'dart:convert';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_event.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget confirmChangePasswordButton({
  required BuildContext context,
  required GlobalKey<FormState> changePasswordFormKey,
  required TextEditingController oldPasswordController,
  required TextEditingController newPasswordController,
  required TextEditingController confirmPasswordController,
  required bool isLoading
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: isLoading ? null : () {
        if (changePasswordFormKey.currentState!.validate()) {
          var oldBytes = utf8.encode(oldPasswordController.text);
          var oldSha512 = sha256.convert(oldBytes);
          var hashedOldPassword = oldSha512.toString();
          var newBytes = utf8.encode(newPasswordController.text);
          var newSha512 = sha256.convert(newBytes);
          var hashedNewPassword = newSha512.toString();
          var confirmBytes = utf8.encode(confirmPasswordController.text);
          var confirmSha512 = sha256.convert(confirmBytes);
          var hashedConfirmPassword = confirmSha512.toString();
          print("Confirm Hashed Password - $hashedConfirmPassword");
          final changePassword = BlocProvider.of<EditPasswordBloc>(context);
          changePassword
              .add(EditPasswordEvent(hashedOldPassword, hashedNewPassword));
        }
      },
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: disabledPrimaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: isLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: onPrimaryColor,),) : normalText(value: "Save", size: 20, color: onPrimaryColor),
    ),
  );
}
