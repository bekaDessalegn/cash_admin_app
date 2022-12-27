import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/loading_box.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/socket_error_widget.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_bloc.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_event.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_state.dart';
import 'package:cash_admin_app/features/orders/presentation/widgets/accept_order_dialog.dart';
import 'package:cash_admin_app/features/orders/presentation/widgets/delete_order_dialog.dart';
import 'package:cash_admin_app/features/orders/presentation/widgets/reject_order_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:progressive_image/progressive_image.dart';

class OrderDetailsBody extends StatefulWidget {

  String orderId;
  OrderDetailsBody({required this.orderId});

  @override
  State<OrderDetailsBody> createState() => _OrderDetailsBodyState();
}

class _OrderDetailsBodyState extends State<OrderDetailsBody> {

  @override
  void initState() {
    final orderDetails = BlocProvider.of<SingleOrderBloc>(context);
    orderDetails.add(GetSingleOrderEvent(widget.orderId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleOrderBloc, SingleOrderState>(builder: (_, state) {
      if (state is GetSingleOrderSuccessful) {
        return buildInitialInput(order: state.order);
      } else if (state is GetSingleOrderFailed) {
        return Center(
          child: SizedBox(
            height: 250,
            child: errorBox(onPressed: (){
              final orderDetails = BlocProvider.of<SingleOrderBloc>(context);
              orderDetails.add(GetSingleOrderEvent(widget.orderId));
            }),
          ),
        );
      } else if(state is GetSingleOrderSocketError){
        return Center(child: socketErrorWidget(onPressed: (){
          final orderDetails = BlocProvider.of<SingleOrderBloc>(context);
          orderDetails.add(GetSingleOrderEvent(widget.orderId));
        }),);
      } else if (state is GetSingleOrderLoading) {
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(child: loadingBox()));
      } else {
        return Center(child: Text(""));
      }
    });
  }

  Widget buildInitialInput({required Orders order}){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                order.product.mainImage!.path == "null" ?
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage("images/default.png"),
                        fit: BoxFit.cover),
                  ),
                ) : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ProgressiveImage(
                    placeholder: AssetImage('images/loading.png'),
                    thumbnail:
                    NetworkImage("$baseUrl${order.product.mainImage!.path}"),
                    image: NetworkImage("$baseUrl${order.product.mainImage!.path}"),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${order.product.productName}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: onBackgroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price",
                          style: TextStyle(
                              color: onBackgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${order.product.price} ETB",
                          style: TextStyle(
                            color: onBackgroundColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Commission",
                          style: TextStyle(
                              color: onBackgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${order.product.commission} ETB",
                          style: TextStyle(
                            color: onBackgroundColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(onPressed: (){},
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: (){
                            context.pushNamed(APP_PAGE.productDetails.toName, params: {'product_id': order.product.productId},);
                          },
                          child: Text(
                            "See product",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Iconify(Ic.baseline_open_in_new, color: primaryColor, size: 16,),
                      ],
                    )),
                SizedBox(height: 10,),
                Divider(color: surfaceColor, thickness: 1.0,),
                SizedBox(height: 10,),
                Text(
                  "Order info",
                  style: TextStyle(
                      color: onBackgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Full Name",
                      style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,),
                    ),
                    Text(
                      "${order.orderedBy.fullName}",
                      style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phone",
                      style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,),
                    ),
                    Text(
                      "${order.orderedBy.phone}",
                      style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                order.orderedBy.companyName.toString() == "null" ? SizedBox() : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Company Name",
                      style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,),
                    ),
                    Text(
                      "${order.orderedBy.companyName}",
                      style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Divider(color: surfaceColor, thickness: 1.0,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Affiliate",
                      style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,),
                    ),
                    GestureDetector(
                      onTap: (){
                        context.pushNamed(APP_PAGE.affiliateDetails.toName, params: {'user_id': order.affiliate!.userId},);
                      },
                      child: Text(
                        "${order.affiliate!.fullName}",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Divider(color: surfaceColor, thickness: 1.0,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,),
                    ),
                    Text(
                      "${order.status}",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Divider(color: surfaceColor, thickness: 1.0,),
                SizedBox(height: 10,),
                order.status == "Pending" ? SizedBox() : TextButton(
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return deleteOrderDialog(
                              context: context,
                              orderId: order.orderId!
                            );
                          });
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: normalText(
                        value: "Delete order", size: 15, color: dangerColor)),
              ],
            ),
            order.status == "Pending" ? patchOrderRow(orderId: order.orderId!) : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget patchOrderRow({required String orderId}){
    return Row(
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(onPressed: (){
            showDialog(
                barrierDismissible: false,
                context: context, builder: (BuildContext context){
              return acceptOrderDialog(context: context, orderId: orderId);
            });
          },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
            ),
            child: Text(
              "Accepted",
              style: TextStyle(
                color: onPrimaryColor,
                fontSize: 20,),
            ),),
        )),
        Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(onPressed: (){
            showDialog(
                barrierDismissible: false,
                context: context, builder: (BuildContext context){
              return rejectOrderDialog(context: context, orderId: orderId);
            });
          },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10),
                backgroundColor: backgroundColor,

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: primaryColor)
                )
            ),
            child: Text(
              "Rejected",
              style: TextStyle(
                color: primaryColor,
                fontSize: 20,),
            ),),
        )),
      ],
    );
  }

}