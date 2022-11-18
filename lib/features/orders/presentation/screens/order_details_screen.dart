import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/orders/presentation/widgets/order_details_body.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {

  String orderId;
  OrderDetailsScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: OrderDetailsBody(orderId: orderId,),
    );
  }
}
