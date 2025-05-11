import 'package:flutter/material.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/my_cart_view_body.dart';

class MyCartView extends StatelessWidget {
  const MyCartView({super.key});

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

class ItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double discount;
  final String shippingInfo;

  const ItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.discount,
    required this.shippingInfo,
  });

  @override
  Widget build(BuildContext context) {
    final discountedPrice = price - (price * (discount / 100));
    double shippingCost = shippingInfo.contains("Free") ? 0.0 : 5.0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyCartViewBody(
              subtotal: price,
              discount: price * (discount / 100),
              shipping: shippingCost,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                '\$${discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green),
              ),
              if (discount > 0)
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                shippingInfo,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
