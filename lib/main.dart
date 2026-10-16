import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: CartScreen()));

// Stores the details of one shopping cart item.
class CartItem {
  final String name;
  final double price;
  int quantity;
  bool gotIt;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    this.gotIt = false,
  });
}

// Stateful because cart items and their quantities can change.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _items = [];

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Preload three sample shopping items.
    _items.addAll([
      CartItem(name: 'Rice', price: 60.00, quantity: 2),
      CartItem(name: 'Eggs', price: 8.00, quantity: 12),
      CartItem(name: 'Milk', price: 95.00, quantity: 1),
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Calculates the total cost of all cart items.
  double get _total =>
      _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Shopping Cart')),
      body: const Center(child: Text('Shopping cart foundation')),
    );
  }
}
