import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_bloc.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_event.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Widget acceptOrderDialog({required BuildContext context, required String orderId}){
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: BlocConsumer<PatchOrderBloc, PatchOrderState>(builder: (_, state){
      if(state is AcceptOrderStateLoading){
        return _buildAcceptOrderInput(context: context, orderId: orderId, isLoading: true);
      } else{
        return _buildAcceptOrderInput(context: context, orderId: orderId, isLoading: false);
      }
    }, listener: (_, state){
      if(state is PatchOrderStateSuccessful){
        final order_details = BlocProvider.of<SingleOrderBloc>(context);
        order_details.add(GetSingleOrderEvent(orderId));
        Navigator.pop(context);
      }
      if(state is PatchOrderStateFailed){
        buildErrorLayout(context: context, message: state.errorType);
      }
    }),
  );
}

Widget _buildAcceptOrderInput({required BuildContext context, required String orderId, required bool isLoading}){
  return SizedBox(
    height: 150,
    width: MediaQuery.of(context).size.width < 500 ? double.infinity : 300,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Accept order", style: TextStyle(
              color: onBackgroundColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 10,),
          Text("Are you sure you want to accept this order ?", style: TextStyle(
              color: onBackgroundColor,
              fontSize: 16
          ),),
          SizedBox(height: 20,),
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
              TextButton(onPressed: (){
                final accept = BlocProvider.of<PatchOrderBloc>(context);
                accept.add(AcceptOrderEvent(orderId));
              }, child: isLoading ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(color: primaryColor,)) : Text("Accept", style: TextStyle(
                  color: primaryColor,
                  fontSize: 16
              ),),),
            ],
          )
        ],
      ),
    ),
  );
}