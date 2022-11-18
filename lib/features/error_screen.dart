import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PageNotFoundScreen extends StatelessWidget {

  String error;
  PageNotFoundScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(
        margin: EdgeInsets.only(top: 50),
        width: 250,
        height: 150,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: surfaceColor),
            borderRadius: BorderRadius.circular(10)
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("PAGE NOT FOUND",
              textAlign: TextAlign.center,
              style: TextStyle(color: onBackgroundColor, fontSize: 22),),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              context.go(APP_PAGE.home.toPath);
            }, child: Text("Go Home", style: TextStyle(color: onPrimaryColor),))
          ],
        ),
      )),
    );
  }
}
