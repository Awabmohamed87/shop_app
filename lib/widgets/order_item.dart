import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItem order;
  const OrderItemCard(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.date)),
        subtitle: Text('${order.amount}\$'),
        children: order.items
            .map((product) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${product.quantity}x \$${product.price}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
