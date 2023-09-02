import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/productDetailScreen';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments.toString();
    final product =
        Provider.of<Products>(context, listen: false).getProduct(id);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(product.title),
                ),
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7)),
              ),
              background: Hero(
                  tag: id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '${product.price}',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                Container(
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
