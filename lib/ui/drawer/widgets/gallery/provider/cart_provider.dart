import 'package:flutter/material.dart';

class PhotoItem {
  final String id;
  final String album;
  final double price;

  PhotoItem({
    required this.id,
    required this.album,
    required this.price,
  });
}

class CartProvider extends ChangeNotifier {
  final List<PhotoItem> _cart = [];
  final List<PhotoItem> _history = [];

  List<PhotoItem> get cart => _cart;
  List<PhotoItem> get history => _history;

  double get total =>
      _cart.fold(0, (sum, item) => sum + item.price);

  void addToCart(PhotoItem item) {
    if (!_cart.any((e) => e.id == item.id)) {
      _cart.add(item);
      notifyListeners();
    }
  }

  void removeFromCart(String id) {
    _cart.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void checkout() {
    _history.addAll(_cart);
    _cart.clear();
    notifyListeners();
  }
}