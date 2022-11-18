import 'dart:convert';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/features/common_widgets/normal_button.dart';
import 'package:cash_admin_app/features/login/data/models/login.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_bloc.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

Widget loginButton(
    {required BuildContext context,
    required String text,
    required bool isLoading}) {
  return isLoading
      ? ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: disabledPrimaryColor,
            backgroundColor: primaryColor,
            foregroundColor: onPrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultRadius)),
            padding: const EdgeInsets.symmetric(vertical: buttonHeight),
          ),
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: onPrimaryColor,
            ),
          ))
      : normalButton(
          text: text,
          onTap: () async {
            if (formkey.currentState!.validate()) {
              var bytes = utf8.encode(passwordController.text);
              var sha512 = sha256.convert(bytes);
              var hashedPassword = sha512.toString();
              final login = BlocProvider.of<LoginBloc>(context);
              login.add(LoginAdminEvent(Login(
                    username: usernameController.text,
                    passwordHash: hashedPassword)));
            }
          },
        );
}
