import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/put_email_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/put_email_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget addEmailButton({required BuildContext context, required TextEditingController emailController, required final verifyEmailKey, required bool isLoading}){
  return ElevatedButton(
    onPressed: () {
      if (verifyEmailKey.currentState!.validate()) {
        final putEmail = BlocProvider.of<PutEmailBloc>(context);
        putEmail.add(PutEmailEvent(emailController.text));
      }
    },
    style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10))),
    child: isLoading
        ? SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: onPrimaryColor,
      ),
    )
        : normalText(
        value: "Save", size: 20, color: onPrimaryColor),
  );
}