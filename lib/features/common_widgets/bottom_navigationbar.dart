import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/home/data/models/header_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/akar_icons.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/majesticons.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';

Widget bottomNavigationBar(BuildContext context, int index){

  List<HeaderItem> headerItems = [
    HeaderItem(title: "Home", icon: Teenyicons.home_outline, onTap: (){
      context.go('/');
    }),
    HeaderItem(title: "Products", icon: Ph.package, onTap: (){
      context.go('/products');
    }),
    HeaderItem(title: "Create", icon: AkarIcons.circle_plus_fill, onTap: (){
      context.go('/add_product');
    }),
    HeaderItem(title: "Orders", icon: Majesticons.clipboard_list_line, onTap: (){
      context.go('/orders');
    }),
    HeaderItem(title: "Affiliate", icon: Bi.people, onTap: (){
      context.go('/affiliate');
    }),
  ];

  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: backgroundColor,
    selectedItemColor: primaryColor,
    currentIndex: index,
    iconSize: 28,
    onTap: (index){
      headerItems[index].onTap();
      // routes[index];
    },
    items: [
      BottomNavigationBarItem(
        icon: Iconify(Teenyicons.home_outline, color: index == 0 ? primaryColor : onBackgroundColor,),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Iconify(Ph.package, color: index == 1 ? primaryColor : onBackgroundColor,),
        label: "Products",
      ),
      BottomNavigationBarItem(
        icon: Iconify(AkarIcons.circle_plus_fill, color: index == 2 ? primaryColor : onBackgroundColor,),
        label: "Create",
      ),
      BottomNavigationBarItem(
        icon: Iconify(Majesticons.clipboard_list_line, color: index == 3 ? primaryColor : onBackgroundColor,),
        label: "Orders",
      ),
      BottomNavigationBarItem(
        icon: Iconify(Bi.people, color: index == 4 ? primaryColor : onBackgroundColor,),
        label: "Affiliates",
      ),
    ],
  );
}