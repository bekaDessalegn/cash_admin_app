import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/big_image.dart';
import 'package:cash_admin_app/features/common_widgets/blink_container.dart';
import 'package:cash_admin_app/features/products/data/models/local_products.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget localFeaturedProductsBox({required BuildContext context, required LocalProducts product}){
  return GestureDetector(
    onTap: (){
      context.goNamed(APP_PAGE.productDetails.toName, params: {'product_id': product.productId},);
    },
    child: Container(
      width: 249,
      height: 255,
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
          BlinkContainer(width: double.infinity, height: 139, borderRadius: 3,),
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
                    product.productName,
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
                Text(
                  "${product.price} ETB",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: onBackgroundColor,
                    fontSize: 16,
                  ),
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