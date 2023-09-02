import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: ((context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : Provider.of<Orders>(context).orders.isEmpty
                      ? Center(
                          child: Text("You don't have any orders yet"),
                        )
                      : Consumer<Orders>(
                          builder: (ctx, orders, child) => ListView.builder(
                            itemCount: orders.orders.length,
                            itemBuilder: (BuildContext context, int index) {
                              return OrderItemCard(orders.orders[index]);
                            },
                          ),
                        ))),
    );
  }
}
