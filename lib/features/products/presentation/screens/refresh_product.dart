import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RefreshProduct extends StatefulWidget {
  const RefreshProduct({Key? key}) : super(key: key);

  @override
  State<RefreshProduct> createState() => _RefreshProductState();
}

class _RefreshProductState extends State<RefreshProduct> {

  @override
  void initState() {
    init();
    // TODO: implement initState
    super.initState();
  }

  Future init() async {
    await Future.delayed(Duration(milliseconds: 20));
    context.go(APP_PAGE.product.toPath);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
