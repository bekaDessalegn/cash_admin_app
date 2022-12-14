import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_bloc.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_event.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget deleteSocialLinkDialog({required BuildContext context, required String id}){
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: BlocConsumer<CustomizeBloc, CustomizeState>(listener: (_, state) {
      if (state is DeleteSocialLinkFailed) {
        buildErrorLayout(context: context, message: state.errorType);
      } else if (state is DeleteSocialLinkSuccessful) {
        final homeContent = BlocProvider.of<HomeContentBloc>(context);
        homeContent.add(GetHomeContentEvent());
        Navigator.pop(context);
      }
    }, builder: (_, state) {
      if (state is DeleteSocialLinkLoading) {
        return buildInitialInput(context: context, isLoading: true, id: id);
      } else {
        return buildInitialInput(context: context, isLoading: false, id: id);
      }
    }),
  );
}

Widget buildInitialInput({required BuildContext context, required bool isLoading, required String id}){
  return SizedBox(
    height: 170,
    width: MediaQuery.of(context).size.width < 1100 ? double.infinity : 400,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Delete social", style: TextStyle(
              color: onBackgroundColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 10,),
          isLoading ? Center(child: CircularProgressIndicator(color: primaryColor,),) :
          Text("Are you sure you want to delete this social ?", style: TextStyle(
              color: onBackgroundColor,
              fontSize: 16
          ),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel", style: TextStyle(
                  color: onBackgroundColor,
                  fontSize: 16
              ),),),
              SizedBox(width: 10,),
              TextButton(onPressed: (){
                final deleteSocialLink = BlocProvider.of<CustomizeBloc>(context);
                deleteSocialLink.add(DeleteSocialLinkEvent(id));
              }, child: Text("Delete", style: TextStyle(
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