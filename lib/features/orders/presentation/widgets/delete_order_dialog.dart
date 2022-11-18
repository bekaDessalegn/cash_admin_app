import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_bloc.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_event.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Widget deleteOrderDialog({required BuildContext context, required String orderId}){
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: BlocConsumer<DeleteOrderBloc, DeleteOrderState>(builder: (_, state){
      if(state is DeleteOrderLoadingState){
        return _buildDeleteOrderInput(context: context, orderId: orderId, isLoading: true);
      } else{
        return _buildDeleteOrderInput(context: context, orderId: orderId, isLoading: false);
      }
    }, listener: (_, state){
      if(state is DeleteOrderSuccessfulState){
        Navigator.pop(context);
        // final orders =
        // BlocProvider.of<OrdersBloc>(context);
        // orders.add(GetOrdersEvent(0));
        MediaQuery.of(context).size.width < 1100 ? context.push(APP_PAGE.order.toPath) : context.go(APP_PAGE.home.toPath);
      }
      if(state is DeleteOrderFailedState){
        buildErrorLayout(context: context, message: state.errorType);
      }
    }),
  );
}

Widget _buildDeleteOrderInput({required BuildContext context, required String orderId, required bool isLoading}){
  return SizedBox(
    height: 150,
    width: MediaQuery.of(context).size.width < 500 ? double.infinity : 300,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Delete order", style: TextStyle(
              color: onBackgroundColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 10,),
          Text("Are you sure you want to delete this order ?", style: TextStyle(
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
                final deleteOrder = BlocProvider.of<DeleteOrderBloc>(context);
                deleteOrder.add(DeleteSingleOrderEvent(orderId));
              }, child: isLoading ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: primaryColor,),) : Text("Delete", style: TextStyle(
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