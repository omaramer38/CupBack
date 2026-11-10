import 'cart_item.dart';

enum OrderStatus {
  received,
  preparing,
  ready,
  completed,
}

class OrderModel {
  final String id;
  final String cafeId;
  final String cafeName;
  final String customerName;
  final String customerPhone;
  final String? customerNotes;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final String? discountReason;
  final String? discountedItemName;
  final String orderType; // Pickup, Dine-in, Delivery
  final String paymentMethod; // Cash on delivery
  OrderStatus status;
  final DateTime createdAt;
  int estimatedMinutesRemaining;
  bool hasBeenRated;

  OrderModel({
    required this.id,
    required this.cafeId,
    required this.cafeName,
    this.customerName = 'عميل CupBack',
    this.customerPhone = '01012345678',
    this.customerNotes,
    required this.items,
    required this.subtotal,
    this.discount = 0.0,
    required this.total,
    this.discountReason,
    this.discountedItemName,
    required this.orderType,
    this.paymentMethod = 'كاش عند الاستلام',
    this.status = OrderStatus.preparing,
    required this.createdAt,
    this.estimatedMinutesRemaining = 12,
    this.hasBeenRated = false,
  });

  OrderModel copyWith({
    String? id,
    String? cafeId,
    String? cafeName,
    String? customerName,
    String? customerPhone,
    String? customerNotes,
    List<CartItem>? items,
    double? subtotal,
    double? discount,
    double? total,
    String? discountReason,
    String? discountedItemName,
    String? orderType,
    String? paymentMethod,
    OrderStatus? status,
    DateTime? createdAt,
    int? estimatedMinutesRemaining,
    bool? hasBeenRated,
  }) {
    return OrderModel(
      id: id ?? this.id,
      cafeId: cafeId ?? this.cafeId,
      cafeName: cafeName ?? this.cafeName,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerNotes: customerNotes ?? this.customerNotes,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      discountReason: discountReason ?? this.discountReason,
      discountedItemName: discountedItemName ?? this.discountedItemName,
      orderType: orderType ?? this.orderType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedMinutesRemaining: estimatedMinutesRemaining ?? this.estimatedMinutesRemaining,
      hasBeenRated: hasBeenRated ?? this.hasBeenRated,
    );
  }

  String get statusTextAr {
    switch (status) {
      case OrderStatus.received:
        return 'تم استلام الطلب';
      case OrderStatus.preparing:
        return 'قيد التحضير في الكافيه';
      case OrderStatus.ready:
        return 'جاهز للاستلام';
      case OrderStatus.completed:
        return 'تم الاستلام بنجاح';
    }
  }

  String get statusTextEn {
    switch (status) {
      case OrderStatus.received:
        return 'Order Received';
      case OrderStatus.preparing:
        return 'Preparing in Café';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.completed:
        return 'Completed';
    }
  }
}
