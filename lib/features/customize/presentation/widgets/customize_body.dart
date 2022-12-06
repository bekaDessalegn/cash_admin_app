import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/customize_about_us_body.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/customize_general_body.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/customize_home_body.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';

class CustomizeBody extends StatelessWidget {
  const CustomizeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
          children: [
            TabBar(
                labelColor: primaryColor,
                indicatorColor: primaryColor,
                unselectedLabelColor: onBackgroundColor,
                tabs: [
              Tab(text: ("General")),
              Tab(text: ("Home")),
              Tab(text: ("About Us")),
            ]),
            Expanded(
              child: TabBarView(children: [
                CustomizeGeneralBody(),
                CustomizeHomeBody(),
                CustomizeAboutUsBody(),
              ]),
            ),
          ],
      ),
    );
  }
}
