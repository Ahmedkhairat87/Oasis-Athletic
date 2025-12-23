import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oasisathletic/ui/drawer/widgets/gallery/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class PurchaseHistory extends StatelessWidget {
  const PurchaseHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<CartProvider>().history;

    return Scaffold(
      appBar: AppBar(title: Text('Purchase History'.tr())),
      body: history.isEmpty
          ? Center(child: Text('No purchases yet'.tr()))
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.image),
          title: Text(history[i].album),
          trailing: Text(
            'Paid'.tr(),
            style: TextStyle(color: Colors.green),
          ),
        ),
      ),
    );
  }
}