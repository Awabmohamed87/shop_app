import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';

import 'screens/splash_scree.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Auth()),
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProxyProvider<Auth, Products>(
        create: (_) => Products(),
        update: (context, authValue, previousProducts) =>
            previousProducts == null
                ? null
                : previousProducts.getData(
                    authValue.token == null ? '' : authValue.token!,
                    authValue.userId,
                    previousProducts.products)),
    ChangeNotifierProxyProvider<Auth, Orders>(
        create: (_) => Orders(),
        update: (context, authValue, previousOrders) => previousOrders == null
            ? null
            : previousOrders.getData(
                authValue.userId,
                authValue.token == null ? '' : authValue.token!,
                previousOrders.orders)),
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
        },
      ),
    );
  }
}
