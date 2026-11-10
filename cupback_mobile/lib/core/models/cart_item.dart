import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedSize;
  final List<String> selectedAddOns;
  final String? selectedSweetness;
  final double unitPrice;
  final String? notes;
  final bool isFreeReward;
  final String? discountLabel;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedAddOns = const [],
    this.selectedSweetness,
    double? unitPrice,
    this.notes,
    this.isFreeReward = false,
    this.discountLabel,
  }) : unitPrice = isFreeReward ? 0.0 : (unitPrice ?? product.price);

  double get totalPrice => isFreeReward ? 0.0 : (unitPrice * quantity);
}
