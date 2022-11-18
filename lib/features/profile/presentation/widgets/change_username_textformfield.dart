import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/services/app_service.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_state.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:provider/provider.dart';

Widget changeUsernameTextFormField({required BuildContext context, required String username}){

  TextEditingController changeUsernameController = TextEditingController();
  changeUsernameController.text = username;
  late AppService appService;
  appService = Provider.of<AppService>(context, listen: false);

  return BlocConsumer<EditPasswordBloc, EditPasswordState>(builder: (_, state){
    if(state is EditPasswordLoading){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: changeUsernameController,
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2.0,),),
          )
        ],
      );
    }
    else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextFormField(
              controller: changeUsernameController,
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
                final admin = BlocProvider.of<EditPasswordBloc>(context);
                admin.add(EditUsernameEvent(changeUsernameController.text));
                print(changeUsernameController.text);
              },
              icon: Iconify(
                Ic.baseline_done,
                size: 24,
                color: primaryColor,
              ))
        ],
      );
    }
  }, listener: (_, state){
    if(state is EditPasswordSuccessful){
      appService.changeIsEditUsername(false);
      final admin = BlocProvider.of<ProfileBloc>(context);
      admin.add(LoadAdminEvent());
    }
  });
}