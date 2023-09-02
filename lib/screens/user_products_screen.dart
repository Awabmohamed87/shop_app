import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatefulWidget {
  static const String routeName = '/user_product_screen';
  const UserProductScreen({super.key});

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text('My products'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts(filterById: true),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      const SizedBox(height: 5),
                      Text('loading..')
                    ],
                  ),
                )
              : Provider.of<Products>(context).products.isEmpty
                  ? Center(child: Text("You don't have any products yet"))
                  : Consumer<Products>(
                      builder: (ctx, products, child) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: products.products.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  UserProductItem(
                                      id: products.products[index].id,
                                      title: products.products[index].title,
                                      imageUrl:
                                          products.products[index].imageUrl),
                            ),
                          ))),
    );
  }
}
