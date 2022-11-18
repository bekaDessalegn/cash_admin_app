import 'package:cash_admin_app/features/affiliate/presentation/widgets/affiliate_details_body.dart';
import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class AffiliateDetailsScreen extends StatelessWidget {

  String userId;
  AffiliateDetailsScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: AffiliateDetailsBody(userId),
    );
  }
}
