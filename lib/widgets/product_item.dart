import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              image: NetworkImage(product.imageUrl),
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
          leading: Consumer<Product>(
            builder: (_, product, child) => IconButton(
                icon: product.isFavourite
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red[600],
                      )
                    : Icon(Icons.favorite_border_outlined),
                onPressed: () => product.toggleFavouriteStatus(
                    Provider.of<Auth>(context, listen: false).token!,
                    Provider.of<Auth>(context, listen: false).userId!)),
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white60,
                  elevation: 0,
                  content: Center(
                    child: Text(
                      '${product.title} successfully added to cart',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO!',
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () => cart.removeSingleItem(product.id),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
