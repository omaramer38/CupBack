class CafeCustomer {
  final String id;
  final String name;
  final String phone;
  final int totalOrders;
  final int stampsCount;
  final double totalSpent;
  final bool isVip;
  final DateTime lastVisit;

  const CafeCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.totalOrders,
    required this.stampsCount,
    required this.totalSpent,
    this.isVip = false,
    required this.lastVisit,
  });

  CafeCustomer copyWith({
    String? id,
    String? name,
    String? phone,
    int? totalOrders,
    int? stampsCount,
    double? totalSpent,
    bool? isVip,
    DateTime? lastVisit,
  }) {
    return CafeCustomer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      totalOrders: totalOrders ?? this.totalOrders,
      stampsCount: stampsCount ?? this.stampsCount,
      totalSpent: totalSpent ?? this.totalSpent,
      isVip: isVip ?? this.isVip,
      lastVisit: lastVisit ?? this.lastVisit,
    );
  }

  String get tierLabelAr =>
      isVip ? 'زبون دائم VIP 🌟' : (totalOrders <= 1 ? 'زبون جديد ☕' : 'زبون متكرر ✨');

  String get lastVisitFormatted {
    final diff = DateTime.now().difference(lastVisit);
    if (diff.inHours < 24) {
      return 'اليوم';
    } else if (diff.inDays == 1) {
      return 'أمس';
    } else {
      return 'منذ ${diff.inDays} أيام';
    }
  }
}
