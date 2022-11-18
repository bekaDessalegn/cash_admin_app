import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/common_widgets/bottom_navigationbar.dart';
import 'package:cash_admin_app/features/orders/presentation/widgets/orders_list_body.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {

  int index = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appbar,
      body: OrdersBody(),
      bottomNavigationBar: bottomNavigationBar(context, index),
    );
  }
}
