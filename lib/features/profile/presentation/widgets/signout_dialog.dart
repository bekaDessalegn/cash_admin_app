import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Widget signoutDialog({required BuildContext context}){
  final authService = Provider.of<AuthService>(context);
  final _prefs = PrefService();
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: BlocConsumer<ProfileBloc, ProfileState>(builder: (_, state){
      if(state is SignOutLoading) {
        return _buildSignoutInput(context: context, isLoading: true);
      }
      else {
        return _buildSignoutInput(context: context, isLoading: false);
      }
    }, listener: (_, state){
      if(state is SignOutSuccessful){
        _prefs.removeCache();
        authService.logOut();
        context.go(APP_PAGE.login.toPath);
      }
      if(state is LoadAdminFailed){
        Navigator.pop(context);
      }
    }),
  );
}

Widget _buildSignoutInput({required BuildContext context, required bool isLoading}){
  return SizedBox(
    height: 170,
    width: MediaQuery.of(context).size.width < 500 ? double.infinity : 300,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text("Sign out", style: TextStyle(
              color: onBackgroundColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 10,),
          Text("Are you sure you want to sign out ?", style: TextStyle(
              color: onBackgroundColor,
              fontSize: 16
          ),),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: isLoading ? null : (){
                Navigator.pop(context);
              }, child: Text("Cancel", style: TextStyle(
                  color: onBackgroundColor,
                  fontSize: 16
              ),),),
              SizedBox(width: 10,),
              TextButton(onPressed: isLoading ? null : (){
                final signout = BlocProvider.of<ProfileBloc>(context);
                signout.add(SignOutEvent());
              }, child: isLoading ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(color: primaryColor,)) : Text("Sign out", style: TextStyle(
                  color: dangerColor,
                  fontSize: 16
              ),),),
            ],
          )
        ],
      ),
    ),
  );
}