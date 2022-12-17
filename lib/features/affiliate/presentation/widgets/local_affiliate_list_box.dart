import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/affiliate/data/models/affiliates.dart';
import 'package:cash_admin_app/features/affiliate/data/models/local_affiliate.dart';
import 'package:cash_admin_app/features/common_widgets/small_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

Widget localAffiliateListBox({required BuildContext context, required LocalAffiliate affiliate}){
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: (){
        context.goNamed(APP_PAGE.affiliateDetails.toName, params: {'user_id': affiliate.userId},);
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
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: AssetImage("images/account.jpg"),
                          fit: BoxFit.cover)),
                ),
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
                              width: 180,
                              child: Text(
                                "${affiliate.fullName}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: onBackgroundColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "${affiliate.phone}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: onBackgroundColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            text: "${affiliate.totalMade.toStringAsFixed(2)} ",
                            style: GoogleFonts.quicksand(fontSize: 16, color: onBackgroundColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "birr earned",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: onBackgroundColor)),
                            ],
                          ),
                        ),
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
    ),
  );
}