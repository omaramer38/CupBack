enum OfferDiscountType {
  freeItem, // طلب مجاني بالكامل
  percentage, // نسبة مئوية (مثلاً 20% أو 30%)
  fixedAmount, // قيمة نقدية مخصومة (مثلاً 25 ج.م)
}

enum OfferScope {
  entireMenu, // على كل المنيو
  specificCategory, // على فئة معينة (مثل المشروبات الباردة)
  specificProduct, // على صنف محدد (مثل سبانش لاتيه)
}

enum OfferTargetAudience {
  allCustomers, // لكل الزبائن
  loyalOnly, // للزبائن الدائمين فقط
  newCustomersOnly, // للزبائن الجدد فقط (عرض ترحيبي)
}

class CafeOffer {
  final String id;
  final String cafeId;
  final String title;
  final String description;
  final int requiredCups; // عدد الأكواب المطلوبة (0 = خصم فوري مباشر)
  final OfferDiscountType discountType;
  final double discountValue; // مثلاً 20.0 للنسبة أو 30.0 للقيمة
  final OfferScope scope;
  final String? targetCategory;
  final String? targetProductId;
  final String? targetProductName;
  final OfferTargetAudience targetAudience;
  final bool isActive;
  final DateTime createdAt;

  const CafeOffer({
    required this.id,
    required this.cafeId,
    required this.title,
    required this.description,
    this.requiredCups = 5,
    this.discountType = OfferDiscountType.percentage,
    this.discountValue = 20.0,
    this.scope = OfferScope.entireMenu,
    this.targetCategory,
    this.targetProductId,
    this.targetProductName,
    this.targetAudience = OfferTargetAudience.allCustomers,
    this.isActive = true,
    required this.createdAt,
  });

  String get audienceLabelAr {
    switch (targetAudience) {
      case OfferTargetAudience.allCustomers:
        return 'لكل الزبائن';
      case OfferTargetAudience.loyalOnly:
        return 'لزبائن الكافيه الدائمين ⭐';
      case OfferTargetAudience.newCustomersOnly:
        return 'عرض ترحيبي للزبائن الجدد 🎁';
    }
  }

  String get discountTypeLabelAr {
    switch (discountType) {
      case OfferDiscountType.freeItem:
        return 'مشروب مجاني بالكامل ☕';
      case OfferDiscountType.percentage:
        return 'خصم ${discountValue.toInt()}%';
      case OfferDiscountType.fixedAmount:
        return 'خصم ${discountValue.toInt()} ج.م';
    }
  }

  String get scopeLabelAr {
    switch (scope) {
      case OfferScope.entireMenu:
        return 'على جميع أصناف المنيو';
      case OfferScope.specificCategory:
        return 'خاص بقسم: ${targetCategory ?? "المشروبات"}';
      case OfferScope.specificProduct:
        return 'خاص بمشروب: ${targetProductName ?? "صنف محدد"}';
    }
  }

  CafeOffer copyWith({
    String? id,
    String? cafeId,
    String? title,
    String? description,
    int? requiredCups,
    OfferDiscountType? discountType,
    double? discountValue,
    OfferScope? scope,
    String? targetCategory,
    String? targetProductId,
    String? targetProductName,
    OfferTargetAudience? targetAudience,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return CafeOffer(
      id: id ?? this.id,
      cafeId: cafeId ?? this.cafeId,
      title: title ?? this.title,
      description: description ?? this.description,
      requiredCups: requiredCups ?? this.requiredCups,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      scope: scope ?? this.scope,
      targetCategory: targetCategory ?? this.targetCategory,
      targetProductId: targetProductId ?? this.targetProductId,
      targetProductName: targetProductName ?? this.targetProductName,
      targetAudience: targetAudience ?? this.targetAudience,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
