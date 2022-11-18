import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_bloc.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget resetButton({required BuildContext context, required final forgotPasswordFormKey, required TextEditingController emailController, required bool isLoading}){
  return ElevatedButton(
    onPressed: isLoading ? null : () {
      if(forgotPasswordFormKey.currentState!.validate()){
        final sendResetLink = BlocProvider.of<LoginBloc>(context);
        sendResetLink.add(SendRecoveryEmailEvent(emailController.text));
      }
    },
    style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        disabledBackgroundColor: disabledPrimaryColor,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10))),
    child: isLoading ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: onPrimaryColor,)) : normalText(
        value: "Send Reset Link", size: 16, color: onPrimaryColor),
  );
}