import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/big_image.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

Widget unAnsweredOrdersBox({required BuildContext context, required Orders order}){
  return GestureDetector(
    onTap: (){
      context.goNamed(APP_PAGE.orderDetails.toName, params: {'order_id': order.orderId!},);
    },
    child: Container(
      width: 249,
      height: 283,
      margin: EdgeInsets.fromLTRB(0, 10, 30, 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          order.product.mainImage!.path.toString() == "null" ?
          Container(
            width: MediaQuery.of(context).size.width,
            height: 139,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/default.png"),
                    fit: BoxFit.cover),
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(10))),
          ) : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: bigImage(urlImage: "$baseUrl${order.product.mainImage!.path}")),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    "${order.product.productName}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: onBackgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Phone: ",
                      style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "${order.orderedBy.phone}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Date: ",
                      style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "${DateFormat("dd/MM/yyyy").format(
                          DateTime.parse("${order.orderedAt}"),
                        )}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ],
      ),
    ),
  );
}