import 'package:flutter/material.dart';

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
        ),
        body: Center(
          child: Text('Home'),
        ),
        drawer: ShopAppDrawer());
  }
}
