import 'package:cash_admin_app/features/affiliate/presentation/widgets/affiliate_body.dart';
import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/common_widgets/bottom_navigationbar.dart';
import 'package:flutter/material.dart';

class AffiliateScreen extends StatelessWidget {

  int index = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appbar,
      body: AffiliatesBody(),
      bottomNavigationBar: bottomNavigationBar(context, index),
    );
  }
}
