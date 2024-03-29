import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/blink_container.dart';
import 'package:cash_admin_app/features/common_widgets/medium_image.dart';
import 'package:cash_admin_app/features/orders/data/models/local_order.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

Widget localOrdersListBox({required BuildContext context, required LocalOrder order}){
  return GestureDetector(
    onTap: (){
      context.goNamed(APP_PAGE.orderDetails.toName, params: {'order_id': order.orderId!},);
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        children: [
          SizedBox(height: 5,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BlinkContainer(width: 84, height: 84, borderRadius: 3,),
              Expanded(
                child: Container(
                  height: 84,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Text(
                              "${order.productName}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "${order.phone}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: onBackgroundColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Affl. ",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: onBackgroundColor,
                                    fontSize: 14,
                                  ),
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: (){

                                    },
                                    child: Text(
                                      "${order.fullName}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${DateFormat("dd/MM/yyyy").format(
                              DateTime.parse("${order.orderedAt}"),
                            )}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: onBackgroundColor,
                              fontSize: 14,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Divider(
            color: surfaceColor,
            thickness: 1.0,
          ),
        ],
      ),
    ),
  );
}