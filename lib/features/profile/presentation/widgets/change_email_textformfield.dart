import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/services/app_service.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:provider/provider.dart';

Widget changeEmailTextFormField({required BuildContext context, required String email}){

  TextEditingController changeEmailController = TextEditingController();
  changeEmailController.text = email;
  late AppService appService;
  appService = Provider.of<AppService>(context, listen: false);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: TextFormField(
          controller: changeEmailController,
          validator: (value){
            if(value!.isEmpty){
              return "Value can not be empty";
            }
            else{
              return null;
            }
          },
          onChanged: (value){},
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: textInputBorderColor),
              borderRadius: BorderRadius.all(
                Radius.circular(defaultRadius),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: dangerColor),
            ),
          ),
        ),
      ),
      IconButton(
          onPressed: () {
            appService.changeIsEditEmail(false);
            print(changeEmailController.text);
          },
          icon: Iconify(
            Ic.baseline_done,
            size: 24,
            color: primaryColor,
          ))
    ],
  );
}