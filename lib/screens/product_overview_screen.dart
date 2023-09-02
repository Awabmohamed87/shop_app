import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';

enum FilterOption { All, Favourites }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  FilterOption _filterOption = FilterOption.All;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: Text('home'),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _filterOption = _filterOption == FilterOption.All
                      ? FilterOption.Favourites
                      : FilterOption.All;
                });
              },
              child: _filterOption == FilterOption.All
                  ? Text('All')
                  : Icon(
                      Icons.star_rate_outlined,
                      color: Colors.yellow[600],
                    ),
            ),
            Consumer<Cart>(
                child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(CartScreen.routeName)),
                builder: (ctx, cart, child) =>
                    MyBadge(child: child!, value: cart.itemCount.toString())),
          ],
        ),
        body: FutureBuilder(
            future: Provider.of<Products>(context, listen: false)
                .fetchAndSetProducts(),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Provider.of<Products>(context).products.isEmpty
                    ? Center(
                        child: Text('No products yet'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProductsGrid(
                            _filterOption == FilterOption.All ? false : true),
                      )),
        drawer: ShopAppDrawer());
  }
}
