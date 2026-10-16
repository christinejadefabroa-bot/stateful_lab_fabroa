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

// Stateful because cart items and their values can change.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _items = [];

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  String? _nameError;
  String? _priceError;

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

  // Calculates the total cost of all items.
  double get _total =>
      _items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  // Increases quantity without exceeding 99.
  void _increase(int index) {
    if (_items[index].quantity >= 99) return;

    setState(() {
      _items[index].quantity++;
    });
  }

  // Decreases quantity without going below 1.
  void _decrease(int index) {
    if (_items[index].quantity <= 1) return;

    setState(() {
      _items[index].quantity--;
    });
  }

  // Updates the checked status of an item.
  void _toggle(int index, bool? value) {
    setState(() {
      _items[index].gotIt = value ?? false;
    });
  }

  // Validates and adds a new shopping item.
  void _addItem() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    setState(() {
      _nameError = name.isEmpty ? 'Enter an item name' : null;
      _priceError = price == null || price <= 0
          ? 'Enter a price greater than 0'
          : null;
    });

    if (_nameError != null || _priceError != null) {
      return;
    }

    setState(() {
      _items.add(CartItem(name: name, price: price!, quantity: 1));

      _nameController.clear();
      _priceController.clear();
      _nameError = null;
      _priceError = null;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$name added to cart')));
  }

  // Removes all items marked as got it.

  void _clearChecked() {
    final checkedCount = _items.where((item) => item.gotIt).length;

    if (checkedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No checked items to clear')),
      );
      return;
    }

    setState(() {
      _items.removeWhere((item) => item.gotIt);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$checkedCount checked item${checkedCount == 1 ? '' : 's'} removed successfully!',
        ),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gotItCount = _items.where((item) => item.gotIt).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Shopping Cart'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary bar with live item count and total.
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Items: ${_items.length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Got it: $gotItCount',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total: PHP ${_total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Form for adding an item.
              const Text(
                'Add New Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item name',
                  hintText: 'e.g. Bread',
                  errorText: _nameError,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
                ),
                onChanged: (_) {
                  if (_nameError != null) {
                    setState(() {
                      _nameError = null;
                    });
                  }
                },
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Price (PHP)',
                  hintText: 'e.g. 25.50',
                  errorText: _priceError,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.payments_outlined),
                ),
                onChanged: (_) {
                  if (_priceError != null) {
                    setState(() {
                      _priceError = null;
                    });
                  }
                },
              ),

              const SizedBox(height: 8),

              ElevatedButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
              ),

              const SizedBox(height: 12),

              // Shopping list heading and clear button.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shopping List',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _clearChecked,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear checked'),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Expanded gives the list a bounded height.
              Expanded(
                child: _items.isEmpty
                    ? const Center(child: Text('Your shopping cart is empty.'))
                    : ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return CartItemTile(
                            item: _items[index],
                            onIncrease: () => _increase(index),
                            onDecrease: () => _decrease(index),
                            onToggle: (value) => _toggle(index, value),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stateless because the parent supplies the item and callbacks.
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<bool?> onToggle;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Checkbox(value: item.gotIt, onChanged: onToggle),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: item.gotIt
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  Text(
                    'PHP ${item.price.toStringAsFixed(2)} each',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Decrease quantity',
              onPressed: item.quantity > 1 ? onDecrease : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              tooltip: 'Increase quantity',
              onPressed: item.quantity < 99 ? onIncrease : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
