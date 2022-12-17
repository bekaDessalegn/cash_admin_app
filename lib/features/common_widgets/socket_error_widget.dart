import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

Widget socketErrorWidget({required VoidCallback onPressed}){
  return Container(
    width: double.infinity,
    height: 160,
    margin: EdgeInsets.symmetric(horizontal: 30),
    padding: EdgeInsets.symmetric(vertical: 30),
    decoration: BoxDecoration(
      border: Border.all(color: surfaceColor)
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(Mdi.access_point_network, size: 30, color: onBackgroundColor,),
            SizedBox(width: 10,),
            Text("No internet connection", style: TextStyle(color: onBackgroundColor, fontSize: 16),)
          ],
        ),
        SizedBox(height: 20,),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10)
            ),
            onPressed: (){
          onPressed();
        }, child: Text("Retry", style: TextStyle(color: onPrimaryColor),))
      ],
    ),
  );
}