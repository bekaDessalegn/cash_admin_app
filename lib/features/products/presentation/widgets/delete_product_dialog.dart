import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Widget deleteProductDialog({required BuildContext context, required String? productId}){
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: BlocConsumer<DeleteProductBloc, DeleteProductState>(listener: (_, state) {
      if (state is DeleteProductFailed) {
        Navigator.pop(context);
        if(state.errorType == "You can not delete this product, it has orders"){
          showDialog(context: context, builder: (BuildContext context){
            return Dialog(
              child: SizedBox(
                height: 160,
                width: MediaQuery.of(context).size.width < 500 ? double.infinity : 400,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Has orders", style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 10,),
                      Text("This product can not be deleted because it has orders, please delete those orders first.", style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16
                      ),),
                      SizedBox(height: 30,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("Ok", style: TextStyle(
                            color: onBackgroundColor,
                            fontSize: 16
                        ),),),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        } else{
          buildErrorLayout(context: context, message: state.errorType);
        }
      } else if (state is DeleteProductSuccessful) {
        final productDetails = BlocProvider.of<SingleProductBloc>(context);
        productDetails.add(DeleteSingleProductEvent());
        context.go(APP_PAGE.refreshProduct.toPath);
      }
    }, builder: (_, state) {
      if (state is DeleteProductLoading) {
        return _buildInitialInput(context: context, productId: productId, isLoading: true);
      } else {
        return _buildInitialInput(context: context, productId: productId, isLoading: false);
      }
    }),
  );
}

Widget _buildInitialInput({required BuildContext context, required String? productId, required bool isLoading}){
  return SizedBox(
    height: 160,
    width: MediaQuery.of(context).size.width < 500 ? double.infinity : 400,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text("Delete product", style: TextStyle(
              color: onBackgroundColor,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 10,),
          isLoading ? Center(child: CircularProgressIndicator(color: primaryColor,),) :
          Text("Are you sure you want to delete this product ?", style: TextStyle(
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
              TextButton(onPressed: isLoading ? null : (){
                final deleteProduct = BlocProvider.of<DeleteProductBloc>(context);
                deleteProduct.add(DeleteProductEvent(productId));
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