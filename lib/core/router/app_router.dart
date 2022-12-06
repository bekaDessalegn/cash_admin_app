import 'dart:convert';

import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/core/services/app_service.dart';
import 'package:cash_admin_app/features/affiliate/presentation/screens/affiliate_details.dart';
import 'package:cash_admin_app/features/affiliate/presentation/screens/affiliate_screen.dart';
import 'package:cash_admin_app/features/affiliate/presentation/screens/transaction_by.dart';
import 'package:cash_admin_app/features/customize/presentation/screens/customize_screen.dart';
import 'package:cash_admin_app/features/error_screen.dart';
import 'package:cash_admin_app/features/home/presentation/screens/home_screen.dart';
import 'package:cash_admin_app/features/login/presentation/screens/forgot_password_screen.dart';
import 'package:cash_admin_app/features/login/presentation/screens/login_screen.dart';
import 'package:cash_admin_app/features/orders/presentation/screens/order_details_screen.dart';
import 'package:cash_admin_app/features/orders/presentation/screens/orders_screen.dart';
import 'package:cash_admin_app/features/products/data/datasources/remote/products_datasource.dart';
import 'package:cash_admin_app/features/products/presentation/screens/add_product.dart';
import 'package:cash_admin_app/features/products/presentation/screens/categories_screen.dart';
import 'package:cash_admin_app/features/products/presentation/screens/edit_product.dart';
import 'package:cash_admin_app/features/products/presentation/screens/product_details.dart';
import 'package:cash_admin_app/features/products/presentation/screens/products_screen.dart';
import 'package:cash_admin_app/features/products/presentation/screens/refresh_product.dart';
import 'package:cash_admin_app/features/profile/presentation/screens/add_email_screen.dart';
import 'package:cash_admin_app/features/profile/presentation/screens/edit_email_screen.dart';
import 'package:cash_admin_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:cash_admin_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:cash_admin_app/features/splashview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  late final AppService appService;

  GoRouter get router => _goRouter;

  AppRouter(this.appService);

  late final GoRouter _goRouter = GoRouter(
      refreshListenable: appService,
      initialLocation: APP_PAGE.home.toPath,
      routes: <GoRoute>[
        GoRoute(
          path: APP_PAGE.home.toPath,
          name: APP_PAGE.home.toName,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: APP_PAGE.splash.toPath,
          name: APP_PAGE.splash.toName,
          builder: (context, state) => const SplashView(),
        ),
        GoRoute(
          path: APP_PAGE.login.toPath,
          name: APP_PAGE.login.toName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: APP_PAGE.product.toPath,
          name: APP_PAGE.product.toName,
          routes: [
            GoRoute(
              path: ':product_id',
              name: APP_PAGE.productDetails.toName,
              builder: (context, state) {
                final productId = state.params['product_id']!;
                return ProductDetailsScreen(productId);
              },
            ),
            GoRoute(
              path: 'edit/:product_id',
              name: APP_PAGE.editProduct.toName,
              builder: (context, state) {
                final productId = state.params['product_id']!;
                final product = jsonEncode(product_contents!.toJson());
                return EditProductScreen(productId: product,);
              },
            ),
          ],
          builder: (context, state) => ProductsScreen(),
        ),
        GoRoute(
          path: APP_PAGE.order.toPath,
          name: APP_PAGE.order.toName,
          routes: [
            GoRoute(
              path: ":order_id",
              name: APP_PAGE.orderDetails.toName,
              builder: (context, state) {
                final orderId = state.params['order_id'];
                return OrderDetailsScreen(orderId: orderId!);
              },
            ),
          ],
          builder: (context, state) => OrdersScreen(),
        ),
        GoRoute(
          path: APP_PAGE.affiliate.toPath,
          name: APP_PAGE.affiliate.toName,
          routes: [
            GoRoute(
              path: ':user_id',
              name: APP_PAGE.affiliateDetails.toName,
              builder: (context, state) {
                final userId = state.params['user_id']!;
                return AffiliateDetailsScreen(userId);
              },
            ),
            GoRoute(
              path: 'transaction/:user_id',
              name: APP_PAGE.transactionBy.toName,
              builder: (context, state) {
                final userId = state.params['user_id']!;
                return TransactionByScreen(userId: userId,);
              },
            ),
          ],
          builder: (context, state) => AffiliateScreen(),
        ),
        GoRoute(
          path: APP_PAGE.profile.toPath,
          name: APP_PAGE.profile.toName,
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: APP_PAGE.addProduct.toPath,
          name: APP_PAGE.addProduct.toName,
          builder: (context, state) => AddProductScreen(),
        ),
        GoRoute(
          path: APP_PAGE.editProfile.toPath,
          name: APP_PAGE.editProfile.toName,
          builder: (context, state) => EditProfileScreen(),
        ),
        GoRoute(
          path: APP_PAGE.addEmail.toPath,
          name: APP_PAGE.addEmail.toName,
          builder: (context, state) => AddEmailScreen(),
        ),
        GoRoute(
          path: APP_PAGE.editEmail.toPath,
          name: APP_PAGE.editEmail.toName,
          builder: (context, state) => const EditEmailScreen(),
        ),
        GoRoute(
          path: APP_PAGE.forgotPassword.toPath,
          name: APP_PAGE.forgotPassword.toName,
          builder: (context, state) => ForgotPasswordScreen(),
        ),
        GoRoute(
          path: APP_PAGE.categories.toPath,
          name: APP_PAGE.categories.toName,
          builder: (context, state) => const CategoriesScreen(),
        ),
        GoRoute(
          path: APP_PAGE.customize.toPath,
          name: APP_PAGE.customize.toName,
          builder: (context, state) => const CustomizeScreen(),
        ),
        GoRoute(
          path: APP_PAGE.refreshProduct.toPath,
          name: APP_PAGE.refreshProduct.toName,
          builder: (context, state) => const RefreshProduct(),
        ),
        GoRoute(
          path: APP_PAGE.error.toPath,
          name: APP_PAGE.error.toName,
          builder: (context, state) =>
              PageNotFoundScreen(error: state.extra.toString()),
        ),
      ],
      errorBuilder: (context, state) =>
          PageNotFoundScreen(error: state.error.toString()),
      redirect: (BuildContext context, GoRouterState state) async {

        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

        final loginLocation = state.namedLocation(APP_PAGE.login.toName);
        final homeLocation = state.namedLocation(APP_PAGE.home.toName);
        final splashLocation = state.namedLocation(APP_PAGE.splash.toName);
        final profileLocation = state.namedLocation(APP_PAGE.profile.toName);
        final forgotPasswordLocation = state.namedLocation(APP_PAGE.forgotPassword.toName);

        final isGoingToForgotPassword = state.subloc == forgotPasswordLocation;
        final isGoingToInit = state.subloc == splashLocation;

        final isLoggedIn = await appService.loginState;
        final isInitialized = await appService.initialized;

        final isGoingToLogin = state.subloc == loginLocation;
        final isGoingToProfile = state.subloc == profileLocation;

        final loggedIn = await sharedPreferences.getBool(LOGIN_KEY) ?? false;


        if (isGoingToForgotPassword) {
          return null;
        }
        else if (!loggedIn && !isGoingToInit && !isInitialized) {
          return splashLocation;
        }
        else if (isInitialized && !loggedIn && !isGoingToLogin) {
          return loginLocation;
        }
        else if ((loggedIn && isGoingToLogin) || (isInitialized && isGoingToInit)) {
          return homeLocation;
        }
        else {
          return null;
        }
      }
      );
}
