import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/oreders_screen.dart';

import 'screens/product_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_scree.dart';
import 'screens/user_products_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Auth()),
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProxyProvider<Auth, Products>(
        create: (_) => Products('', ''),
        update: (context, authValue, previousProducts) => Products(
            authValue.token == null ? '' : authValue.token!,
            authValue.userId == null ? '' : authValue.userId!)),
    ChangeNotifierProxyProvider<Auth, Orders>(
      create: (_) => Orders(authToken: '', userId: ''),
      update: (context, authValue, previousOrders) => Orders(
          authToken: authValue.token == null ? '' : authValue.token!,
          userId: authValue.userId == null ? '' : authValue.userId!),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          canvasColor: Colors.deepOrange,
          fontFamily: 'Lato',
          useMaterial3: true,
        ),
        home: auth.isAuth
            ? ProductOverviewScreen()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen(),
              ),
        routes: {
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          UserProductScreen.routeName: (_) => UserProductScreen(),
          EditProductScreen.routeName: (_) => EditProductScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
        },
      ),
    );
  }
}
