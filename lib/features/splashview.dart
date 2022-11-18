import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/core/services/app_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  late AppService _appService;
  final _prefs = PrefService();

  @override
  void initState() {
    _prefs.readCache().then((value) {
      if(value == null){
        context.go(APP_PAGE.login.toPath);
      }
      else{
        context.go(APP_PAGE.home.toPath);
      }
    });
    _appService = Provider.of<AppService>(context, listen: false);
    onStartUp();
    super.initState();
  }

  void onStartUp() async {
    await _appService.onAppStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
