import 'package:flutter/material.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/item_card.dart';

class MyCartListView extends StatelessWidget {
  const MyCartListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7, // controls card height
          children: const [
            ItemCard(
              imageUrl:
                  'assets/images/controller.jpg', // replace with your asset
              title: 'Smart Watch',
              price: 199.99,
              discount: 20,
              shippingInfo: 'Free Shipping',
            ),
            ItemCard(
              imageUrl: 'assets/images/controller.jpg',
              title: 'Headphones',
              price: 89.99,
              discount: 10,
              shippingInfo: '\$5 Shipping',
            ),
            ItemCard(
              imageUrl:
                  'assets/images/controller.jpg', // replace with your asset
              title: 'Smart Watch',
              price: 199.99,
              discount: 20,
              shippingInfo: 'Free Shipping',
            ),
            ItemCard(
              imageUrl: 'assets/images/controller.jpg',
              title: 'Headphones',
              price: 89.99,
              discount: 10,
              shippingInfo: '\$5 Shipping',
            ),
            // Add more cards as needed
          ],
        ),
      ),
    );
  }
}
