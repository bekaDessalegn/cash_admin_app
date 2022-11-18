import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/product_details_body.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {

  String productId;
  ProductDetailsScreen(this.productId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: ProductDetailsBody(productId: productId, imageSize: 172,),
    );
  }
}
