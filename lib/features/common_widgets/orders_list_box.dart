import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/medium_image.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

Widget ordersListBox({required BuildContext context, required Orders order}){
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
              order.product.mainImage!.path == "null" ?
              Container(
                height: 84,
                width: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  image: DecorationImage(
                      image: AssetImage("images/default.png"),
                      fit: BoxFit.cover),
                ),
              ) : ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: mediumImage(urlImage: "$baseUrl${order.product.mainImage!.path}")),
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
                              "${order.product.productName}",
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
                            "${order.orderedBy.phone}",
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
                                      if(order.affiliate!.userId != "123"){
                                        context.pushNamed(APP_PAGE.affiliateDetails.toName, params: {'user_id': order.affiliate!.userId},);
                                      }
                                    },
                                    child: Text(
                                      "${order.affiliate!.fullName}",
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