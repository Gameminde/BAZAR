import 'package:flutter/material.dart';
import 'package:bazar_marketplace_app/utils/bazar_theme.dart';
import 'package:bazar_marketplace_app/screens/bazar_home/bazar_home_screen.dart';
import 'package:bazar_marketplace_app/screens/product_detail/product_detail_screen.dart';
import 'package:bazar_marketplace_app/screens/checkout/checkout_screen.dart';

class BazarDemoApp extends StatelessWidget {
  const BazarDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bazar Marketplace',
      theme: BazarTheme.lightTheme,
      darkTheme: BazarTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const BazarHomeScreen(),
        '/product-detail': (context) => ProductDetailScreen(
              productId: '1',
              productName: 'JMDA MaxLift 001',
              price: 189.99,
              oldPrice: 249.99,
              rating: 4.7,
              reviews: 234,
              images: const [
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
                'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa',
                'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a',
                'https://images.unsplash.com/photo-1460353581641-37baddab0fa2',
              ],
              description: 'Experience ultimate comfort and performance with the JMDA MaxLift 001. Designed for athletes and active individuals, these shoes feature advanced cushioning technology, breathable materials, and superior grip for all-day wear.',
              sizes: const ['7', '8', '8.5', '9', '9.5', '10', '11'],
              colors: const [
                Color(0xFF000000),
                Color(0xFFFF5722),
                Color(0xFF2196F3),
                Color(0xFF4CAF50),
                Color(0xFFE91E63),
              ],
            ),
        '/checkout': (context) => CheckoutScreen(
              cartItems: [
                {
                  'name': 'JMDA MaxLift 001',
                  'price': 189.99,
                  'quantity': 1,
                  'size': '9',
                  'color': 'Black',
                  'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
                },
                {
                  'name': 'Wireless Headphones Pro',
                  'price': 299.99,
                  'quantity': 1,
                  'size': 'One Size',
                  'color': 'White',
                  'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
                },
              ],
              subtotal: 489.98,
              shipping: 4.00,
              tax: 4.00,
            ),
      },
      onGenerateRoute: (settings) {
        // Handle dynamic routes
        if (settings.name == '/order-confirmation') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => OrderConfirmationScreen(
              orderNumber: args['orderNumber'],
              total: args['total'],
            ),
          );
        }
        return null;
      },
    );
  }
}

// Demo navigation helper
class BazarNavigator {
  static void goToProductDetail(BuildContext context) {
    Navigator.pushNamed(context, '/product-detail');
  }

  static void goToCheckout(BuildContext context) {
    Navigator.pushNamed(context, '/checkout');
  }

  static void goToOrderConfirmation(BuildContext context, String orderNumber, double total) {
    Navigator.pushNamed(
      context,
      '/order-confirmation',
      arguments: {
        'orderNumber': orderNumber,
        'total': total,
      },
    );
  }

  static void goHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}