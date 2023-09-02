import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final String itemId;
  const CartItemCard({super.key, required this.cartItem, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(itemId),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Remove ${cartItem.title} from cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text('Confirm'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Cancel'),
                      )
                    ],
                  ));
        },
        onDismissed: (_) =>
            Provider.of<Cart>(context, listen: false).removeItem(itemId),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(cartItem.title),
              subtitle: Text('${cartItem.price * cartItem.quantity}\$'),
              trailing: Text('${cartItem.quantity} x'),
            ),
          ),
        ));
  }
}
