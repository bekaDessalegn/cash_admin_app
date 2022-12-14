import 'package:cash_admin_app/features/common_widgets/logo_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarLogo extends StatelessWidget {
  const AppBarLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.go('/');
      },
      child: PlatformLogoImage(logoBorderRadius: 0, logoWidth: 120, logoHeight: 50,),
    );
  }
}
