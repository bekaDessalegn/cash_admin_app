import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/create_button.dart';
import 'package:cash_admin_app/features/common_widgets/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: surfaceColor, width: 1.0)
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: (){
                context.go(APP_PAGE.home.toPath);
              },
              child: Container(
                width: 160,
                height: 51,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("images/cash_logo.png"), fit: BoxFit.cover)
                ),
              ),
            ),
          ),
          CreateButton(context: context, horizontal: 16, vertical: 15, fontSize: defaultFontSize),
        ],
      ),
    );
  }
}


