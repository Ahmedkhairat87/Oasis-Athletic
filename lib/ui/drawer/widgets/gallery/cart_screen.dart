import 'package:flutter/material.dart';
import 'package:oasisathletic/ui/drawer/widgets/gallery/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/reusable_components/app_background.dart';
import 'purchase_history.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cart'),
        actions: [
          TextButton(
            child: const Text('History'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PurchaseHistory(),
              ),
            ),
          ),
        ],
      ),
      body: AppBackground(
        child: Column(
          children: [
            Expanded(
              child: cart.cart.isEmpty
                  ? const Center(child: Text('Cart is empty'))
                  : ListView.builder(
                itemCount: cart.cart.length,
                itemBuilder: (_, i) {
                  final item = cart.cart[i];
                  return ListTile(
                    title: Text(item.album),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          cart.removeFromCart(item.id),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Total: ${cart.total} L.E'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: cart.cart.isEmpty
                        ? null
                        : () {
                      cart.checkout();
                      Navigator.pop(context);
                    },
                    child: const Text('Pay'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}