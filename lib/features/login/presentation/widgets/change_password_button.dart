// import 'dart:convert';
//
// import 'package:cash_admin/core/constants.dart';
// import 'package:cash_admin/features/common_widgets/normal_text.dart';
// import 'package:cash_admin/features/login/presentation/blocs/login_bloc.dart';
// import 'package:cash_admin/features/login/presentation/blocs/login_event.dart';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// Widget changePasswordButton({required BuildContext context, required final recoverPasswordFormKey, required TextEditingController newPasswordController, required TextEditingController confirmPasswordController, required bool isLoading}){
//   return ElevatedButton(
//     onPressed: () {
//       if (recoverPasswordFormKey.currentState!.validate()) {
//         var newBytes = utf8.encode(newPasswordController.text);
//         var newSha512 = sha256.convert(newBytes);
//         var hashedNewPassword = newSha512.toString();
//         var confirmBytes =
//         utf8.encode(confirmPasswordController.text);
//         var confirmSha512 = sha256.convert(confirmBytes);
//         var hashedConfirmPassword = confirmSha512.toString();
//         final resetPassword = BlocProvider.of<LoginBloc>(context);
//         final recoveryToken = Uri.base.queryParameters['t'];
//         resetPassword.add(
//             ResetEmailEvent(recoveryToken!, hashedNewPassword));
//       }
//     },
//     style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         backgroundColor: primaryColor,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10))),
//     child: isLoading
//         ? SizedBox(
//       height: 20,
//       width: 20,
//       child: CircularProgressIndicator(
//         color: onPrimaryColor,
//       ),
//     )
//         : normalText(
//         value: "Change Password",
//         size: 16,
//         color: onPrimaryColor),
//   );
// }