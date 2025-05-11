import 'package:flutter/material.dart';
import 'package:payment_app/features/payment/presentation/views/widgets/my_cart_view_body.dart';

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
    final shippingCost = shippingInfo.contains("Free") ? 0.0 : 5.0;
    final totalPrice = discountedPrice + shippingCost;

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
                'Price: \$${discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green),
              ),
              if (discount > 0)
                Text(
                  'Was: \$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                shippingInfo,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              Text(
                'Total: \$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
