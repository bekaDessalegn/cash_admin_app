import 'dart:async';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/provider/locale_provider.dart';
import 'package:cash_admin_app/core/router/app_router.dart';
import 'package:cash_admin_app/core/services/app_service.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/features/affiliate/data/datasources/remote/affiliates_datasource.dart';
import 'package:cash_admin_app/features/affiliate/data/datasources/remote/transactions_datasource.dart';
import 'package:cash_admin_app/features/affiliate/data/repositories/affiliate_transactions_repository.dart';
import 'package:cash_admin_app/features/affiliate/data/repositories/affiliates_repository.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliate_transactions/transactions_bloc.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_bloc.dart';
import 'package:cash_admin_app/features/customize/data/datasource/customize_datasource.dart';
import 'package:cash_admin_app/features/customize/data/repository/customize_repository.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_bloc.dart';
import 'package:cash_admin_app/features/home/data/datasources/remote/home_datasource.dart';
import 'package:cash_admin_app/features/home/data/repositories/home_repository.dart';
import 'package:cash_admin_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:cash_admin_app/features/home/presentation/blocs/home_event.dart';
import 'package:cash_admin_app/features/login/data/datasources/login_data_source.dart';
import 'package:cash_admin_app/features/login/data/repositories/login_repository.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_bloc.dart';
import 'package:cash_admin_app/features/orders/data/datasources/remote/orders_datasource.dart';
import 'package:cash_admin_app/features/orders/data/repositories/orders_repository.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_bloc.dart';
import 'package:cash_admin_app/features/products/data/datasources/remote/products_datasource.dart';
import 'package:cash_admin_app/features/products/data/models/selectedCategory.dart';
import 'package:cash_admin_app/features/products/data/repositories/products_repositories.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_bloc.dart';
import 'package:cash_admin_app/features/profile/data/datasources/remote/profile_datasource.dart';
import 'package:cash_admin_app/features/profile/data/repositories/profile_repository.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/put_email_bloc.dart';
import 'package:cash_admin_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  usePathUrlStrategy();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({Key? key, required this.sharedPreferences,}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppService appService;
  late AuthService authService;
  late StreamSubscription<bool> authSubscription;

  @override
  void initState() {
    appService = AppService(widget.sharedPreferences);
    authService = AuthService();
    authSubscription = authService.onAuthStateChange.listen(onAuthStateChange);
    super.initState();
  }

  void onAuthStateChange(bool login) {
    appService.loginState = login;
  }

  @override
  void dispose() {
    authSubscription.cancel();
    super.dispose();
  }

  final loginRepository = LoginRepository(LoginDataSource());
  final profileRepository = ProfileRepository(ProfileDataSource());
  final productsRepository = ProductsRepository(ProductsDataSource());
  final homeRepository = HomeRepository(HomeDataSource());
  final customizeRepository = CustomizeRepository(CustomizeDataSource());
  final affiliateRepository = AffiliatesRepository(AffiliatesDataSource());
  final ordersRepository = OrdersRepository(OrdersDataSource());
  final transactionsRepository = TransactionsRepository(TransactionsDataSource());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(loginRepository)),
        BlocProvider(create: (_) => ProfileBloc(profileRepository)..add(LoadAdminEvent())),
        BlocProvider(create: (_) => EditPasswordBloc(profileRepository)),
        BlocProvider(create: (_) => PutEmailBloc(profileRepository)),
        BlocProvider(create: (_) => ProductsBloc(productsRepository)),
        BlocProvider(create: (_) => SearchProductBloc(productsRepository)),
        BlocProvider(create: (_) => DeleteProductBloc(productsRepository)),
        BlocProvider(create: (_) => SingleProductBloc(productsRepository)),
        BlocProvider(create: (_) => FilterFeaturedBloc(homeRepository)),
        BlocProvider(create: (_) => FilterTopSellerBloc(homeRepository)),
        BlocProvider(create: (_) => FilterUnAnsweredBloc(homeRepository)),
        BlocProvider(create: (_) => StaticWebContentBloc(homeRepository)),
        BlocProvider(create: (_) => AnalyticsBloc(homeRepository)),
        BlocProvider(create: (_) => CustomizeBloc(customizeRepository)),
        BlocProvider(create: (_) => HomeContentBloc(customizeRepository)),
        BlocProvider(create: (_) => LogoImageBloc(customizeRepository)),
        BlocProvider(create: (_) => AboutUsContentBloc(customizeRepository)),
        BlocProvider(create: (_) => CategoriesBloc(productsRepository)),
        BlocProvider(create: (_) => PostCategoriesBloc(productsRepository)),
        BlocProvider(create: (_) => AffiliatesBloc(affiliateRepository)),
        BlocProvider(create: (_) => SearchAffiliateBloc(affiliateRepository)),
        BlocProvider(create: (_) => SingleAffiliateBloc(affiliateRepository)),
        BlocProvider(create: (_) => ParentAffiliateBloc(affiliateRepository)),
        BlocProvider(create: (_) => ChildrenBloc(affiliateRepository)),
        BlocProvider(create: (_) => OrdersBloc(ordersRepository)),
        BlocProvider(create: (_) => SearchOrderBloc(ordersRepository)),
        BlocProvider(create: (_) => SingleOrderBloc(ordersRepository)),
        BlocProvider(create: (_) => PatchOrderBloc(ordersRepository)),
        BlocProvider(create: (_) => DeleteOrderBloc(ordersRepository)),
        BlocProvider(create: (_) => AffiliateTransactionsBloc(transactionsRepository)),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AppService>(create: (_) => appService),
          Provider<AppRouter>(create: (_) => AppRouter(appService)),
          Provider<AuthService>(create: (_) => authService),
          ChangeNotifierProvider(create: (context) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => SelectedCategory()),
        ],
        child: Builder(
          builder: (context) {

            final GoRouter goRouter = Provider.of<AppRouter>(context, listen: false).router;

            final provider = Provider.of<LocaleProvider>(context);

            Map<int, Color> color = {
              50: const Color.fromRGBO(136, 14, 79, .1),
              100: const Color.fromRGBO(136, 14, 79, .2),
              200: const Color.fromRGBO(136, 14, 79, .3),
              300: const Color.fromRGBO(136, 14, 79, .4),
              400: const Color.fromRGBO(136, 14, 79, .5),
              500: const Color.fromRGBO(136, 14, 79, .6),
              600: const Color.fromRGBO(136, 14, 79, .7),
              700: const Color.fromRGBO(136, 14, 79, .8),
              800: const Color.fromRGBO(136, 14, 79, .9),
              900: const Color.fromRGBO(136, 14, 79, 1),
            };
            return StreamProvider<InternetConnectionStatus>(
              initialData: InternetConnectionStatus.connected,
              create: (_) {
                return InternetConnectionChecker().onStatusChange;
              },
              child: MaterialApp.router(
                routeInformationProvider: goRouter.routeInformationProvider,
                routerDelegate: goRouter.routerDelegate,
                routeInformationParser: goRouter.routeInformationParser,
                debugShowCheckedModeBanner: false,
                title: 'Cash Admin',
                theme: ThemeData(
                  primarySwatch: MaterialColor(0xFFF57721, color),
                  scaffoldBackgroundColor: backgroundColor,
                  textTheme: GoogleFonts.quicksandTextTheme(
                    Theme.of(context).textTheme,
                  ),
                ),
                locale: provider.locale,
                supportedLocales: L10n.all,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
