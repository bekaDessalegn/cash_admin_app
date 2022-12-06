enum APP_PAGE {
  splash,
  login,
  home,
  profile,
  product,
  order,
  affiliate,
  addProduct,
  editProduct,
  editProfile,
  productDetails,
  orderDetails,
  affiliateDetails,
  transactionBy,
  addEmail,
  editEmail,
  forgotPassword,
  // recoveryPassword,
  categories,
  customize,
  refreshProduct,
  error
}

extension AppPageExtension on APP_PAGE {
  String get toPath {
    switch (this) {
      case APP_PAGE.home:
        return "/";
      case APP_PAGE.splash:
        return "/splash";
      case APP_PAGE.login:
        return "/login";
      case APP_PAGE.profile:
        return "/profile";
      case APP_PAGE.product:
        return "/products";
      case APP_PAGE.order:
        return "/orders";
      case APP_PAGE.affiliate:
        return "/affiliate";
      case APP_PAGE.addProduct:
        return "/add_product";
      case APP_PAGE.editProduct:
        return "/edit_product";
      case APP_PAGE.editProfile:
        return "/edit_profile";
      case APP_PAGE.orderDetails:
        return "/order_details";
      case APP_PAGE.affiliateDetails:
        return "/affiliate_details";
      case APP_PAGE.transactionBy:
        return "/transaction_by";
      case APP_PAGE.addEmail:
        return "/add_email";
      case APP_PAGE.editEmail:
        return "/edit_email";
      case APP_PAGE.forgotPassword:
        return "/forgot_password";
      // case APP_PAGE.recoveryPassword:
      //   return "/recovery_password";
      case APP_PAGE.categories:
        return "/categories";
      case APP_PAGE.customize:
        return "/customize";
      case APP_PAGE.error:
        return "/error";
      case APP_PAGE.refreshProduct:
        return "/refresh_product";
      default:
        return "/";
    }
  }

  String get toName {
    switch (this) {
      case APP_PAGE.splash:
        return "SPLASH";
      case APP_PAGE.home:
        return "HOME";
      case APP_PAGE.login:
        return "LOGIN";
      case APP_PAGE.profile:
        return "PROFILE";
      case APP_PAGE.product:
        return "PRODUCTS";
      case APP_PAGE.order:
        return "ORDERS";
      case APP_PAGE.affiliate:
        return "AFFILIATE";
      case APP_PAGE.addProduct:
        return "ADD_PRODUCT";
      case APP_PAGE.editProduct:
        return "EDIT_PRODUCT";
      case APP_PAGE.editProfile:
        return "EDIT_PROFILE";
      case APP_PAGE.productDetails:
        return "PRODUCT_DETAILS";
      case APP_PAGE.orderDetails:
        return "ORDER_DETAILS";
      case APP_PAGE.affiliateDetails:
        return "AFFILIATE_DETAILS";
      case APP_PAGE.transactionBy:
        return "TRANSACTION_BY";
      case APP_PAGE.addEmail:
        return "ADD_EMAIL";
      case APP_PAGE.editEmail:
        return "EDIT_EMAIL";
      case APP_PAGE.forgotPassword:
        return "FORGOT_PASSWORD";
      // case APP_PAGE.recoveryPassword:
      //   return "RECOVERY_PASSWORD";
      case APP_PAGE.categories:
        return "CATEGORIES";
      case APP_PAGE.customize:
        return "CUSTOMIZE";
      case APP_PAGE.error:
        return "ERROR";
      case APP_PAGE.refreshProduct:
        return "REFRESH_PRODUCT";
      default:
        return "HOME";
    }
  }
}
