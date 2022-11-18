import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/medium_image.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

Widget productListBox({required BuildContext context, required Products products}) {
  return GestureDetector(
    onTap: () {
      context.goNamed(APP_PAGE.productDetails.toName, params: {'product_id': products.productId!},);
    },
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    products.mainImage!.path == "null" ?
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
                        child: mediumImage(urlImage: "$baseUrl${products.mainImage!.path}")),
                    Container(
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
                                width:
                                MediaQuery.of(context).size.width - 200,
                                child: Text(
                                  products.productName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: onBackgroundColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "${products.price} ETB",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: onBackgroundColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 97,
                            child: Row(
                              children: [
                                Icon(Icons.remove_red_eye_outlined, size: 18, color: onBackgroundColor,),
                                SizedBox(width: 5,),
                                Text(
                                  "${products.viewCount}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: onBackgroundColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 84,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                        },
                        child: Iconify(
                          Bi.pin_angle,
                          size: 20,
                          color: products.featured!
                              ? primaryColor
                              : onBackgroundInactiveColor,
                        )),
                    GestureDetector(
                        onTap: () {
                        },
                        child: Iconify(
                          Bi.upload,
                          size: 20,
                          color: products.published!
                              ? primaryColor
                              : onBackgroundInactiveColor,
                        )),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 5,),
          Divider(
            color: surfaceColor,
            thickness: 1.0
          ),
        ],
      ),
    ),
  );
}
