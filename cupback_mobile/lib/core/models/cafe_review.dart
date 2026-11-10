class CafeReview {
  final String id;
  final String cafeId;
  final String cafeName;
  final String orderId;
  final String customerName;
  final String customerPhone;
  final double rating; // 1.0 to 5.0
  final String comment;
  final List<String> tags;
  final DateTime createdAt;

  const CafeReview({
    required this.id,
    required this.cafeId,
    required this.cafeName,
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.rating,
    required this.comment,
    this.tags = const [],
    required this.createdAt,
  });

  String get timeAgoAr {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes < 1 ? 1 : diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 30) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  String get timeAgoEn {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes < 1 ? 1 : diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 30) {
      return '${diff.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}
