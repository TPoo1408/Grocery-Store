import 'package:flutter/material.dart';

import 'package:store_user/data/models/category.dart';
import 'package:store_user/data/models/product.dart';
import 'package:store_user/data/models/store.dart';
import 'package:store_user/presentation/pages/account/about_page.dart';
import 'package:store_user/presentation/pages/account/account_page.dart';
import 'package:store_user/presentation/pages/account/help_page.dart';
import 'package:store_user/presentation/pages/account/my_details_page.dart';
import 'package:store_user/presentation/pages/account/notifications_page.dart';
import 'package:store_user/presentation/pages/auth/forgot_password_page.dart';
import 'package:store_user/presentation/pages/auth/login_page.dart';
import 'package:store_user/presentation/pages/auth/onboarding_page.dart';
import 'package:store_user/presentation/pages/auth/register_page.dart';
import 'package:store_user/presentation/pages/explore/category_products_page.dart';
import 'package:store_user/presentation/pages/explore/explore_page.dart';
import 'package:store_user/presentation/pages/explore/product_details_page.dart';
import 'package:store_user/presentation/pages/explore/search_page.dart';
import 'package:store_user/presentation/pages/explore/store_details_page.dart';
import 'package:store_user/presentation/pages/explore/stores_page.dart';
import 'package:store_user/presentation/pages/home/favorites_page.dart';
import 'package:store_user/presentation/pages/home/home_page.dart';
import 'package:store_user/presentation/pages/order/cart_page.dart';
import 'package:store_user/presentation/pages/order/orders_page.dart';
import 'package:store_user/presentation/pages/splash_page.dart';

class AppRouter {
  static const String aboutRoute = '/about';
  static const String accountRoute = '/account';
  static const String categoryProductsRoute = '/category-products';
  static const String cartRoute = '/cart';
  static const String exploreRoute = '/explore';
  static const String favoritesRoute = '/favorite';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String helpRoute = '/help';
  static const String homeRoute = '/home';
  static const String myDetailsRoute = '/my-details';
  static const String notificationsRoute = '/notifications';
  static const String onboardingRoute = '/onboarding';
  static const String ordersRoute = '/orders';
  static const String productDetailsRoute = '/product-details';
  static const String registerPhoneRoute = '/register-phone';
  static const String searchRoute = '/search';
  static const String selectLocationRoute = '/select-location';
  static const String setLocationMapRoute = '/set-location-map';
  static const String storesRoute = '/stores';
  static const String storeDetailsRoute = '/store-details';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String splashRoute = '/splash';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case aboutRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const AboutPage(),
        );
      case accountRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const AccountPage(),
        );
      case categoryProductsRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              CategoryProductsPage(category: settings.arguments as Category),
        );
      case cartRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const CartPage(),
        );
      case exploreRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const ExplorePage(),
        );
      case favoritesRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const FavoritesPage(),
        );
      case forgotPasswordRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const ForgotPasswordPage(),
        );
      case helpRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HelpPage(),
        );
      case homeRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomePage(),
        );
      case myDetailsRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const MyDetailsPage(),
        );
      case notificationsRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const NotificationsPage(),
        );
      case onboardingRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const OnboardingPage(),
        );
      case ordersRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const OrdersPage(),
        );
      case productDetailsRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ProductDetailsPage(
            product: settings.arguments as Product,
          ),
        );
      case searchRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SearchPage(
            query: settings.arguments as String,
          ),
        );
      case storesRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const StoresPage(),
        );
      case storeDetailsRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => StoreDetailsPage(
            store: settings.arguments as Store,
          ),
        );
      case loginRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const LoginPage(),
        );
      case registerRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const RegisterPage(),
        );
      case splashRoute:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const SplashPage(),
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
