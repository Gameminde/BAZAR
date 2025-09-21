/*
 * BAZAR Marketplace - Centralized Router
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/authentication/sign_in/sign_in_screen.dart';
import '../features/authentication/sign_up/sign_up_screen.dart';
import '../features/products/product_detail/product_detail_screen.dart';
import '../features/products/categories/categories_screen.dart';
import '../features/cart/cart_screen/cart_screen.dart';
import '../features/cart/checkout/checkout_screen.dart';
import '../features/user/dashboard/dashboard_screen.dart';
import '../screens/bazar_home/bazar_home_screen.dart';
import '../screens/splash_screen/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String productDetail = '/product/:id';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String dashboard = '/dashboard';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const BazarHomeScreen(),
      ),
      GoRoute(
        path: signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: productDetail,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page non trouvée'),
      ),
    ),
  );
}