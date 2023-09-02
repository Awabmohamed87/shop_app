import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class ProductsGrid extends StatefulWidget {
  final bool showOnlyFavourites;
  const ProductsGrid(this.showOnlyFavourites, {super.key});

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  @override
  Widget build(BuildContext context) {
    List<Product> productsToDisplay = !widget.showOnlyFavourites
        ? Provider.of<Products>(context).products
        : Provider.of<Products>(context).favouriteProducts;
    return GridView.builder(
      itemCount: productsToDisplay.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: productsToDisplay[index], child: ProductItem()),
    );
  }
}
