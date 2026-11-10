import 'package:flutter/material.dart';
import '../models/user_session.dart';
import '../models/product.dart';
import '../models/cafe.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';
import '../models/cafe_review.dart';
import '../models/cafe_offer.dart';
import '../models/cafe_customer.dart';
import '../localization/app_strings.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  final String? infoMessage;

  const AuthResult({
    required this.success,
    this.errorMessage,
    this.infoMessage,
  });
}

class AdminCafePartner {
  final String cafeId;
  final String cafeName;
  final String ownerName;
  final String phone;
  final String pinCode;

  const AdminCafePartner({
    required this.cafeId,
    required this.cafeName,
    required this.ownerName,
    required this.phone,
    this.pinCode = '1234',
  });
}

class AppState extends ChangeNotifier {
  Locale _locale = const Locale('ar', 'EG');
  UserSession? _session = const UserSession(
    name: 'أحمد محمود',
    phone: '01012345678',
    role: UserRole.customer,
    isActivated: true,
  );

  // Pre-approved Café partners registered manually by Admin
  final Map<String, AdminCafePartner> _adminApprovedCafes = {
    '01012345671': const AdminCafePartner(
      cafeId: 'cafe_1',
      cafeName: 'مقهى الزيتون',
      ownerName: 'كابتن طارق',
      phone: '01012345671',
    ),
    '01098765432': const AdminCafePartner(
      cafeId: 'cafe_1',
      cafeName: 'مقهى الزيتون',
      ownerName: 'كابتن طارق',
      phone: '01098765432',
    ),
    '01011112222': const AdminCafePartner(
      cafeId: 'cafe_2',
      cafeName: 'كافيه أروما',
      ownerName: 'م. محمد',
      phone: '01011112222',
    ),
    '01022223333': const AdminCafePartner(
      cafeId: 'cafe_3',
      cafeName: 'مقهى البلدة',
      ownerName: 'أ. محمود',
      phone: '01022223333',
    ),
    '01033334444': const AdminCafePartner(
      cafeId: 'cafe_4',
      cafeName: 'روسترز هب (Roasters)',
      ownerName: 'شريف كمال',
      phone: '01033334444',
    ),
  };

  // In-memory registered users by phone
  final Map<String, UserSession> _registeredUsersByPhone = {
    '01012345678': const UserSession(
      name: 'أحمد محمود',
      phone: '01012345678',
      role: UserRole.customer,
      isActivated: true,
    ),
    '01098765432': const UserSession(
      name: 'كابتن طارق',
      phone: '01098765432',
      role: UserRole.businessOwner,
      businessName: 'مقهى الزيتون',
      ownerContactPhone: '01098765432',
      isActivated: true,
    ),
  };

  // ---------------------------------------------------------------------------
  // Cafes Catalog (Partner Network)
  // ---------------------------------------------------------------------------
  late final List<Cafe> _cafes;

  // Favorites
  final Set<String> _favoriteCafeIds = {'cafe_1'};

  // Cafe Order Counts (How many orders customer placed at each specific cafe)
  final Map<String, int> _cafeOrderCounts = {
    'cafe_1': 4,
    'cafe_2': 3,
    'cafe_3': 2,
    'cafe_4': 5,
  };

  // Cart
  final List<CartItem> _cart = [];
  String? _cartCafeId;
  String? _cartCafeName;

  // Active Orders
  OrderModel? _activeOrder;
  final List<OrderModel> _orderHistory = [];
  final List<OrderModel> _cafeOrders = [];

  // Admin Configurable Limits & Reviews
  int _adminMaxCafePhotos = 4;
  final List<CafeReview> _reviews = [];

  // Café Partner Offers & Customers
  final List<CafeOffer> _offers = [];
  final List<CafeCustomer> _cafeCustomers = [];

  AppState() {
    _initCafesData();
    _initSampleActiveOrder();
    _initSampleReviews();
    _initSampleOffers();
    _initSampleCustomers();
  }

  void _initCafesData() {
    _cafes = [
      Cafe(
        id: 'cafe_1',
        name: 'مقهى الزيتون',
        nameEn: 'Zeitoun Specialty Coffee',
        category: 'قهوة مختصة ومخبوزات',
        location: 'شارع الاستاد، كفر الشيخ',
        rating: 4.9,
        reviewsCount: 142,
        isOpen: true,
        distance: '800 متر',
        requiredOrdersForReward: 6,
        activeOffer: 'خصم 20% على المشروبات الباردة',
        activeOfferDetails: 'سارٍ على جميع أصناف السبانش لاتيه والكولد برو عند الدفع كاش أو الاستلام من الفرع.',
        phone: '01012345671',
        image: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=700&auto=format&fit=crop&q=80',
        logo: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=200&auto=format&fit=crop&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=800&auto=format&fit=crop&q=80',
        ],
        menu: [
          const Product(
            id: 'p1_1',
            cafeId: 'cafe_1',
            name: 'سبانش لاتيه مثلج',
            nameEn: 'Iced Spanish Latte',
            description: 'إسبريسو غني مع حليب مكثف محلى وحليب بارد ومكعبات ثلج منعشة.',
            price: 75.0,
            category: 'مشروبات باردة',
            image: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p1_2',
            cafeId: 'cafe_1',
            name: 'قهوة مقطرة V60 إثيوبي',
            nameEn: 'Ethiopian V60 Pourover',
            description: 'محصول إثيوبي فاخر بإيحاءات الفواكه والزهور وتحضير يدوي دقيق.',
            price: 70.0,
            category: 'قهوة مختصة',
            image: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p1_3',
            cafeId: 'cafe_1',
            name: 'فلات وايت مزدوج',
            nameEn: 'Double Flat White',
            description: 'دبل شوت إسبريسو مع طبقة مايكروفوم حليب مخملية وسلسة.',
            price: 65.0,
            category: 'إسبريسو وحليب',
            image: 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p1_4',
            cafeId: 'cafe_1',
            name: 'كوكيز شوكولاتة بلجيكية',
            nameEn: 'Belgian Chocolate Cookies',
            description: 'كوكيز طازجة دافئة محشوة بقطع شوكولاتة بلجيكية داكنة.',
            price: 35.0,
            category: 'مخبوزات وحلويات',
            image: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p1_5',
            cafeId: 'cafe_1',
            name: 'كرواسون زبدة فرنسي',
            nameEn: 'French Butter Croissant',
            description: 'كرواسون مقرمش وهش ومخبوز يومياً بأجود أنواع الزبدة.',
            price: 40.0,
            category: 'مخبوزات وحلويات',
            image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500&auto=format&fit=crop&q=80',
          ),
        ],
      ),
      Cafe(
        id: 'cafe_2',
        name: 'كافيه أروما (Aroma)',
        nameEn: 'Aroma Coffee Lab',
        category: 'إسبريسو بار ومثلجات',
        location: 'حي الجامعة، كفر الشيخ',
        rating: 4.7,
        reviewsCount: 98,
        isOpen: true,
        distance: '1.4 كم',
        requiredOrdersForReward: 5,
        activeOffer: 'كوبون مجاني بعد 5 أكواب',
        activeOfferDetails: 'اطلب 5 مرات واستلم مشروبك السادس مجاناً تماماً من اختيارك.',
        phone: '01012345672',
        image: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=700&auto=format&fit=crop&q=80',
        logo: 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=200&auto=format&fit=crop&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&auto=format&fit=crop&q=80',
        ],
        menu: [
          const Product(
            id: 'p2_1',
            cafeId: 'cafe_2',
            name: 'كورتادو سنجل أوريجن',
            nameEn: 'Single Origin Cortado',
            description: 'نسبة متوازنة 1:1 من الإسبريسو القوي والحليب الدافئ المبخر.',
            price: 60.0,
            category: 'إسبريسو وحليب',
            image: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p2_2',
            cafeId: 'cafe_2',
            name: 'آيس كراميل ماكياتو',
            nameEn: 'Iced Caramel Macchiato',
            description: 'طبقات فانيليا مع حليب بارد وإسبريسو وتزيين صوص كراميل ذهبي.',
            price: 75.0,
            category: 'مشروبات باردة',
            image: 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p2_3',
            cafeId: 'cafe_2',
            name: 'أمريكانو مثلج منعش',
            nameEn: 'Iced Americano',
            description: 'شوت إسبريسو مزدوج مع ماء مثلج لنكهة قوية ونقية.',
            price: 50.0,
            category: 'مشروبات باردة',
            image: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p2_4',
            cafeId: 'cafe_2',
            name: 'تشيز كيك نيويورك بصوص التوت',
            nameEn: 'Berry Cheesecake',
            description: 'تشيز كيك كريمية غنية مع صوص توت بري طازج ولذيذ.',
            price: 65.0,
            category: 'مخبوزات وحلويات',
            image: 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=500&auto=format&fit=crop&q=80',
          ),
        ],
      ),
      Cafe(
        id: 'cafe_3',
        name: 'مقهى البلدة',
        nameEn: 'Balad Café & Lounge',
        category: 'قهوة عربية وشاي تركي',
        location: 'شارع الجيش، كفر الشيخ',
        rating: 4.8,
        reviewsCount: 110,
        isOpen: true,
        distance: '650 متر',
        requiredOrdersForReward: 6,
        activeOffer: 'خصم 15% على إجمالي الفاتورة',
        activeOfferDetails: 'خصم فوري عند تسجيل الرميات واستلام الطلب من الكافيه.',
        phone: '01012345673',
        image: 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=700&auto=format&fit=crop&q=80',
        logo: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=200&auto=format&fit=crop&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&auto=format&fit=crop&q=80',
        ],
        menu: [
          const Product(
            id: 'p3_1',
            cafeId: 'cafe_3',
            name: 'قهوة تركي مخصوصة بالهيل',
            nameEn: 'Turkish Cardamom Coffee',
            description: 'بن محمص طازج ومطحون مع هيل أخضر على الرمل الساخن.',
            price: 35.0,
            category: 'قهوة تقليدية',
            image: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p3_2',
            cafeId: 'cafe_3',
            name: 'شاي كرك بالحليب والبهارات',
            nameEn: 'Spiced Karak Tea',
            description: 'شاي ثقيل مطبوخ بالحليب المركز مع حب الهال والزعفران.',
            price: 35.0,
            category: 'شاي ومشروبات دافئة',
            image: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p3_3',
            cafeId: 'cafe_3',
            name: 'لاتيه بندق دافئ',
            nameEn: 'Hazelnut Warm Latte',
            description: 'إسبريسو وحليب مبخر مع نكهة البندق المحمص الفاخرة.',
            price: 60.0,
            category: 'إسبريسو وحليب',
            image: 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p3_4',
            cafeId: 'cafe_3',
            name: 'وافل كريسبي نوتيلا وموز',
            nameEn: 'Nutella Banana Waffle',
            description: 'وافل بلجيكي مقرمش مغطى بشوكولاتة نوتيلا وشرائح موز.',
            price: 70.0,
            category: 'مخبوزات وحلويات',
            image: 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=500&auto=format&fit=crop&q=80',
          ),
        ],
      ),
      Cafe(
        id: 'cafe_4',
        name: 'روسترز هب (Roasters)',
        nameEn: 'Roasters Hub Coffee',
        category: 'محمصة حبوب بن طازجة',
        location: 'شارع النبوي المهندس، كفر الشيخ',
        rating: 4.9,
        reviewsCount: 215,
        isOpen: false,
        distance: '2.1 كم',
        requiredOrdersForReward: 6,
        activeOffer: 'كوبون خصم 25% ترحيبي',
        activeOfferDetails: 'كوبون ترحيبي خاص بزبائن CupBack عند أول طلب من المحمصة.',
        phone: '01012345674',
        image: 'https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=700&auto=format&fit=crop&q=80',
        logo: 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=200&auto=format&fit=crop&q=80',
        gallery: [
          'https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=800&auto=format&fit=crop&q=80',
          'https://images.unsplash.com/photo-1518832553480-cd0e625ed3e6?w=800&auto=format&fit=crop&q=80',
        ],
        menu: [
          const Product(
            id: 'p4_1',
            cafeId: 'cafe_4',
            name: 'كولد برو منقوع 18 ساعة',
            nameEn: '18-hr Cold Brew',
            description: 'مستخلص ببطء على البارد لنكهة ناعمة وحمضية خفيفة جداً.',
            price: 80.0,
            category: 'مشروبات باردة',
            image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p4_2',
            cafeId: 'cafe_4',
            name: 'قهوة مقطرة كيمكس (Chemex)',
            nameEn: 'Chemex Pourover',
            description: 'تحضير فلتر سميك لنقاء استثنائي يبرز كل نوتات المحصول.',
            price: 75.0,
            category: 'قهوة مختصة',
            image: 'https://images.unsplash.com/photo-1518832553480-cd0e625ed3e6?w=500&auto=format&fit=crop&q=80',
          ),
          const Product(
            id: 'p4_3',
            cafeId: 'cafe_4',
            name: 'دوناتس فستق حلبي',
            nameEn: 'Pistachio Glazed Donut',
            description: 'دونات هشة طازجة مغطاة بكريمة فستق طبيعية غنية.',
            price: 45.0,
            category: 'مخبوزات وحلويات',
            image: 'https://images.unsplash.com/photo-1527515862127-a4fc05baf7a5?w=500&auto=format&fit=crop&q=80',
          ),
        ],
      ),
    ];
  }

  void _initSampleActiveOrder() {
    final zeitoun = _cafes.first;
    _activeOrder = OrderModel(
      id: '1042',
      cafeId: zeitoun.id,
      cafeName: zeitoun.name,
      customerName: 'أحمد محمود',
      customerPhone: '01012345678',
      customerNotes: 'تسخين الكوكيز لو سمحت واستلام بدون سكر إضافي',
      items: [
        CartItem(product: zeitoun.menu[0], quantity: 1), // Iced Spanish Latte (75)
        CartItem(product: zeitoun.menu[3], quantity: 1), // Cookies (35)
      ],
      subtotal: 110.0,
      discount: 0.0,
      total: 110.0,
      orderType: 'استلام من الكافيه (Pickup)',
      paymentMethod: 'كاش عند الاستلام',
      status: OrderStatus.preparing,
      createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
      estimatedMinutesRemaining: 9,
    );

    _cafeOrders.addAll([
      OrderModel(
        id: '1043',
        cafeId: zeitoun.id,
        cafeName: zeitoun.name,
        customerName: 'محمد عبد الله',
        customerPhone: '01077778888',
        customerNotes: 'مشروب بارد جداً وبدون سكر - استلام سريع',
        items: [
          CartItem(
            product: zeitoun.menu[0],
            quantity: 2,
            discountLabel: 'خصم 20% على المشروبات الباردة (-30 ج.م)',
          ), // 2x Spanish Latte
        ],
        subtotal: 150.0,
        discount: 30.0,
        total: 120.0,
        discountReason: 'خصم ترويجي 20% على المشروبات الباردة',
        discountedItemName: 'سبانش لاتيه مثلج',
        orderType: 'استلام من الكافيه (Pickup)',
        paymentMethod: 'كاش عند الاستلام',
        status: OrderStatus.received,
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        estimatedMinutesRemaining: 14,
      ),
      _activeOrder!,
      OrderModel(
        id: '1041',
        cafeId: zeitoun.id,
        cafeName: zeitoun.name,
        customerName: 'سارة إبراهيم',
        customerPhone: '01066667777',
        customerNotes: 'مكافأة ولاء مجانية 🎁 (استبدال الكوب السادس المجاني)',
        items: [
          CartItem(
            product: zeitoun.menu[2],
            quantity: 1,
            isFreeReward: true,
            discountLabel: 'كوب مجاني بالكامل 🎁',
          ), // Flat White
        ],
        subtotal: 65.0,
        discount: 65.0,
        total: 0.0,
        discountReason: 'مكافأة ولاء: الكوب السادس مجاني بالكامل (خصم 100%)',
        discountedItemName: 'فلات وايت مزدوج',
        orderType: 'استلام من الكافيه (Pickup)',
        paymentMethod: 'كوبون ولاء مجاني',
        status: OrderStatus.ready,
        createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
        estimatedMinutesRemaining: 0,
      ),
      OrderModel(
        id: '1040',
        cafeId: zeitoun.id,
        cafeName: zeitoun.name,
        customerName: 'كريم عادل',
        customerPhone: '01055554444',
        items: [
          CartItem(product: zeitoun.menu[1], quantity: 1), // V60 Pourover
        ],
        subtotal: 70.0,
        discount: 0.0,
        total: 70.0,
        orderType: 'تناول في الكافيه (Dine-in)',
        paymentMethod: 'كاش عند الاستلام',
        status: OrderStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        estimatedMinutesRemaining: 0,
        hasBeenRated: true,
      ),
      OrderModel(
        id: '1039',
        cafeId: zeitoun.id,
        cafeName: zeitoun.name,
        customerName: 'منى مصطفى',
        customerPhone: '01099990000',
        items: [
          CartItem(product: zeitoun.menu[2], quantity: 2), // 2x Flat White
        ],
        subtotal: 130.0,
        discount: 0.0,
        total: 130.0,
        orderType: 'استلام من الكافيه (Pickup)',
        paymentMethod: 'كاش عند الاستلام',
        status: OrderStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
        estimatedMinutesRemaining: 0,
        hasBeenRated: true,
      ),
    ]);
  }

  void _initSampleReviews() {
    _reviews.addAll([
      CafeReview(
        id: 'rev_1',
        cafeId: 'cafe_1',
        cafeName: 'مقهى الزيتون',
        orderId: '1038',
        customerName: 'كريم عادل',
        customerPhone: '01055554444',
        rating: 5.0,
        comment: 'السبانش لاتيه هنا عالمي والتغليف ممتاز جداً! الاستلام كان سريع وما أخدش دقيقتين.',
        tags: const ['☕ قهوة مظبوطة', '⚡ سرعة استلام', '👨‍🍳 باريستا محترف'],
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CafeReview(
        id: 'rev_2',
        cafeId: 'cafe_1',
        cafeName: 'مقهى الزيتون',
        orderId: '1029',
        customerName: 'سارة إبراهيم',
        customerPhone: '01066667777',
        rating: 4.8,
        comment: 'المكان رايق جداً والديكور ممتاز، والـ V60 الإثيوبي نكهتها واضحة ونظيفة.',
        tags: const ['☕ قهوة مظبوطة', '🤍 تعامل راقي'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CafeReview(
        id: 'rev_3',
        cafeId: 'cafe_2',
        cafeName: 'كافيه أروما (Aroma)',
        orderId: '1015',
        customerName: 'محمد سامح',
        customerPhone: '01088889999',
        rating: 4.7,
        comment: 'الكورتادو مظبوط والتعامل لطيف، بس كان في زحمة شوية وقت الظهر.',
        tags: const ['☕ قهوة مظبوطة', '🥐 طازج ولذيذ'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CafeReview(
        id: 'rev_4',
        cafeId: 'cafe_3',
        cafeName: 'مقهى البلدة',
        orderId: '1004',
        customerName: 'عمر خالد',
        customerPhone: '01022221111',
        rating: 4.9,
        comment: 'أحلى قهوة تركي ع الرمل مع هيل ممكن تدوقها، والوافل سخن ومقرمش.',
        tags: const ['☕ قهوة مظبوطة', '🥐 طازج ولذيذ', '🤍 تعامل راقي'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ]);
  }

  void _initSampleOffers() {
    _offers.addAll([
      CafeOffer(
        id: 'off_1',
        cafeId: 'cafe_1',
        title: 'عرض الولاء: كوب مجاني بالكامل 🎁',
        description: 'اجمع 6 أكواب واستلم مشروبك السابع مجاناً من أي صنف في المنيو.',
        requiredCups: 6,
        discountType: OfferDiscountType.freeItem,
        discountValue: 0.0,
        scope: OfferScope.entireMenu,
        targetAudience: OfferTargetAudience.loyalOnly,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      CafeOffer(
        id: 'off_2',
        cafeId: 'cafe_1',
        title: 'عرض ترحيبي: خصم 25% للزبائن الجدد 🔥',
        description: 'خصم فوري 25% على أول أوردر لأي زبون جديد في الكافيه.',
        requiredCups: 0,
        discountType: OfferDiscountType.percentage,
        discountValue: 25.0,
        scope: OfferScope.entireMenu,
        targetAudience: OfferTargetAudience.newCustomersOnly,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      CafeOffer(
        id: 'off_3',
        cafeId: 'cafe_1',
        title: 'خصم 20% على المشروبات الباردة ❄️',
        description: 'خصم خاص على جميع أصناف السبانش لاتيه والكولد برو.',
        requiredCups: 0,
        discountType: OfferDiscountType.percentage,
        discountValue: 20.0,
        scope: OfferScope.specificCategory,
        targetCategory: 'مشروبات باردة',
        targetAudience: OfferTargetAudience.allCustomers,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CafeOffer(
        id: 'off_4',
        cafeId: 'cafe_2',
        title: 'كوبون مجاني بعد 5 أكواب ☕',
        description: 'استلم مشروبك السادس مجاناً من اختيارك.',
        requiredCups: 5,
        discountType: OfferDiscountType.freeItem,
        discountValue: 0.0,
        scope: OfferScope.entireMenu,
        targetAudience: OfferTargetAudience.loyalOnly,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ]);
  }

  void _initSampleCustomers() {
    _cafeCustomers.addAll([
      CafeCustomer(
        id: 'cust_1',
        name: 'أحمد محمود',
        phone: '01012345678',
        totalOrders: 8,
        stampsCount: 4,
        totalSpent: 620.0,
        isVip: true,
        lastVisit: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      CafeCustomer(
        id: 'cust_2',
        name: 'كريم عادل',
        phone: '01055554444',
        totalOrders: 5,
        stampsCount: 5,
        totalSpent: 390.0,
        isVip: true,
        lastVisit: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CafeCustomer(
        id: 'cust_3',
        name: 'سارة إبراهيم',
        phone: '01066667777',
        totalOrders: 3,
        stampsCount: 3,
        totalSpent: 215.0,
        isVip: false,
        lastVisit: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CafeCustomer(
        id: 'cust_4',
        name: 'محمد عبد الله',
        phone: '01077778888',
        totalOrders: 1,
        stampsCount: 1,
        totalSpent: 85.0,
        isVip: false,
        lastVisit: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CafeCustomer(
        id: 'cust_5',
        name: 'منى مصطفى',
        phone: '01099990000',
        totalOrders: 1,
        stampsCount: 1,
        totalSpent: 75.0,
        isVip: false,
        lastVisit: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------
  Locale get locale => _locale;
  UserSession? get session => _session;
  List<Cafe> get cafes => _cafes;
  Set<String> get favoriteCafeIds => _favoriteCafeIds;
  List<CartItem> get cart => _cart;
  String? get cartCafeId => _cartCafeId;
  String? get cartCafeName => _cartCafeName;
  OrderModel? get activeOrder => (_activeOrder != null && _activeOrder!.status != OrderStatus.completed) ? _activeOrder : null;
  OrderModel? get rawActiveOrder => _activeOrder;
  List<OrderModel> get orderHistory => _orderHistory;

  void clearActiveOrder() {
    _activeOrder = null;
    notifyListeners();
  }

  bool get isLoggedIn => _session != null;
  bool get isCustomer => _session?.role == UserRole.customer;
  bool get isBusiness => _session?.role == UserRole.businessOwner;
  bool get isBusinessPending => isBusiness && !(_session?.isActivated ?? false);
  bool get isBusinessActivated => isBusiness && (_session?.isActivated ?? false);

  AppStrings get strings => AppStrings(_locale.languageCode);

  int get cartTotalItems => _cart.fold(0, (sum, item) => sum + item.quantity);
  double get cartSubtotal => _cart.fold(0.0, (sum, item) => sum + item.totalPrice);

  static String normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'\D'), '');
  }

  // ---------------------------------------------------------------------------
  // Localization & Language
  // ---------------------------------------------------------------------------
  void setLocale(Locale newLocale) {
    if (_locale.languageCode != newLocale.languageCode) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'ar') {
      _locale = const Locale('en', 'US');
    } else {
      _locale = const Locale('ar', 'EG');
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Favorites Management
  // ---------------------------------------------------------------------------
  bool isFavorite(String cafeId) => _favoriteCafeIds.contains(cafeId);

  void toggleFavorite(String cafeId) {
    if (_favoriteCafeIds.contains(cafeId)) {
      _favoriteCafeIds.remove(cafeId);
    } else {
      _favoriteCafeIds.add(cafeId);
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Cafe-Specific Loyalty Tracker (How many orders placed & remaining for offer)
  // ---------------------------------------------------------------------------
  int getOrdersCountForCafe(String cafeId) {
    return _cafeOrderCounts[cafeId] ?? 0;
  }

  int getRemainingOrdersForReward(String cafeId) {
    final cafe = _cafes.firstWhere((c) => c.id == cafeId, orElse: () => _cafes.first);
    final count = getOrdersCountForCafe(cafeId);
    final required = cafe.requiredOrdersForReward;
    final remaining = required - (count % required);
    return remaining == 0 ? required : remaining;
  }

  // ---------------------------------------------------------------------------
  // Shopping Cart Logic
  // ---------------------------------------------------------------------------
  void addToCart(
    Product product,
    String cafeName, {
    int quantity = 1,
    String? selectedSize,
    List<String> selectedAddOns = const [],
    String? selectedSweetness,
    double? unitPrice,
    String? notes,
  }) {
    // If cart has items from another cafe, prompt or reset to the new cafe
    if (_cartCafeId != null && _cartCafeId != product.cafeId) {
      _cart.clear();
    }

    _cartCafeId = product.cafeId;
    _cartCafeName = cafeName;

    final effectiveUnitPrice = unitPrice ?? product.price;

    final existingIndex = _cart.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == selectedSize &&
        item.selectedSweetness == selectedSweetness &&
        _listEquals(item.selectedAddOns, selectedAddOns));

    if (existingIndex >= 0) {
      _cart[existingIndex].quantity += quantity;
    } else {
      _cart.add(CartItem(
        product: product,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedAddOns: List.from(selectedAddOns),
        selectedSweetness: selectedSweetness,
        unitPrice: effectiveUnitPrice,
        notes: notes,
      ));
    }
    notifyListeners();
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void updateCartQuantity(String productId, int delta) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final newQty = _cart[index].quantity + delta;
      if (newQty <= 0) {
        _cart.removeAt(index);
        if (_cart.isEmpty) {
          _cartCafeId = null;
          _cartCafeName = null;
        }
      } else {
        _cart[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    if (_cart.isEmpty) {
      _cartCafeId = null;
      _cartCafeName = null;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _cartCafeId = null;
    _cartCafeName = null;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Order Placement & Tracking (Cash on Delivery/Pickup)
  // ---------------------------------------------------------------------------
  OrderModel placeOrder({
    required String orderType,
    String? notes,
  }) {
    assert(_cart.isNotEmpty, 'Cart cannot be empty when placing an order');

    final orderId = '${1000 + DateTime.now().millisecond + _orderHistory.length}';
    final currentCafeId = _cartCafeId!;
    final currentCafeName = _cartCafeName!;
    final total = cartSubtotal;

    final order = OrderModel(
      id: orderId,
      cafeId: currentCafeId,
      cafeName: currentCafeName,
      customerName: _session?.name.isNotEmpty == true ? _session!.name : 'عميل جديد',
      customerPhone: _session?.phone.isNotEmpty == true ? _session!.phone : '01012345678',
      customerNotes: notes,
      items: List.from(_cart),
      subtotal: total,
      discount: 0.0,
      total: total,
      orderType: orderType,
      paymentMethod: 'كاش عند الاستلام (Cash on Pickup)',
      status: OrderStatus.received,
      createdAt: DateTime.now(),
      estimatedMinutesRemaining: 15,
    );

    _activeOrder = order;
    _orderHistory.insert(0, order);
    _cafeOrders.insert(0, order);

    // Increase loyalty orders count for this specific cafe!
    final previousCount = _cafeOrderCounts[currentCafeId] ?? 0;
    _cafeOrderCounts[currentCafeId] = previousCount + 1;

    // Clear cart after checkout
    _cart.clear();
    _cartCafeId = null;
    _cartCafeName = null;

    notifyListeners();
    return order;
  }

  void advanceActiveOrderStatus() {
    if (_activeOrder != null) {
      switch (_activeOrder!.status) {
        case OrderStatus.received:
          _activeOrder!.status = OrderStatus.preparing;
          _activeOrder!.estimatedMinutesRemaining = 10;
          break;
        case OrderStatus.preparing:
          _activeOrder!.status = OrderStatus.ready;
          _activeOrder!.estimatedMinutesRemaining = 2;
          break;
        case OrderStatus.ready:
          _activeOrder!.status = OrderStatus.completed;
          _activeOrder!.estimatedMinutesRemaining = 0;
          break;
        case OrderStatus.completed:
          break;
      }
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Admin Gallery Settings & Compression Limits
  // ---------------------------------------------------------------------------
  int get adminMaxCafePhotos => _adminMaxCafePhotos;

  void setAdminMaxCafePhotos(int limit) {
    if (limit > 0 && limit <= 12) {
      _adminMaxCafePhotos = limit;
      notifyListeners();
    }
  }

  bool addCafeGalleryPhoto(String cafeId, String photoUrl, {int? estimatedRawKb}) {
    final index = _cafes.indexWhere((c) => c.id == cafeId);
    if (index < 0) return false;

    final cafe = _cafes[index];
    if (cafe.gallery.length >= _adminMaxCafePhotos) {
      return false; // Limit reached
    }

    final updatedGallery = List<String>.from(cafe.gallery)..add(photoUrl);
    _cafes[index] = cafe.copyWith(gallery: updatedGallery);
    notifyListeners();
    return true;
  }

  void removeCafeGalleryPhoto(String cafeId, int photoIndex) {
    final index = _cafes.indexWhere((c) => c.id == cafeId);
    if (index >= 0) {
      final cafe = _cafes[index];
      if (photoIndex >= 0 && photoIndex < cafe.gallery.length) {
        final updatedGallery = List<String>.from(cafe.gallery)..removeAt(photoIndex);
        _cafes[index] = cafe.copyWith(gallery: updatedGallery);
        notifyListeners();
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Customer Reviews & Ratings System
  // ---------------------------------------------------------------------------
  List<CafeReview> get allReviews => _reviews;

  List<CafeReview> getReviewsForCafe(String cafeId) {
    return _reviews.where((r) => r.cafeId == cafeId).toList();
  }

  void addCafeReview({
    required String cafeId,
    required String orderId,
    required double rating,
    required String comment,
    List<String> tags = const [],
  }) {
    final cafeIndex = _cafes.indexWhere((c) => c.id == cafeId);
    final cafeName = cafeIndex >= 0 ? _cafes[cafeIndex].name : 'كافيه';
    final customerName = _session?.name ?? 'عميل كاب باك';
    final customerPhone = _session?.phone ?? '01012345678';

    final review = CafeReview(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      cafeId: cafeId,
      cafeName: cafeName,
      orderId: orderId,
      customerName: customerName,
      customerPhone: customerPhone,
      rating: rating,
      comment: comment,
      tags: tags,
      createdAt: DateTime.now(),
    );

    _reviews.insert(0, review);

    // Recalculate Cafe Rating & Reviews Count
    if (cafeIndex >= 0) {
      final cafe = _cafes[cafeIndex];
      final currentTotalRating = cafe.rating * cafe.reviewsCount;
      final newReviewsCount = cafe.reviewsCount + 1;
      final newRating = double.parse(((currentTotalRating + rating) / newReviewsCount).toStringAsFixed(1));

      _cafes[cafeIndex] = cafe.copyWith(
        rating: newRating,
        reviewsCount: newReviewsCount,
      );
    }

    // Mark active order as rated if matches
    if (_activeOrder != null && _activeOrder!.id == orderId) {
      _activeOrder!.hasBeenRated = true;
    }
    for (final order in _orderHistory) {
      if (order.id == orderId) {
        order.hasBeenRated = true;
      }
    }

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Café Live Orders & KDS Workflow
  // ---------------------------------------------------------------------------
  List<OrderModel> getCafeOrders(String cafeId) {
    return _cafeOrders;
  }

  void updateCafeOrderStatus(String orderId, OrderStatus newStatus) {
    final idx = _cafeOrders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _cafeOrders[idx].status = newStatus;
    }
    if (_activeOrder != null && _activeOrder!.id == orderId) {
      _activeOrder!.status = newStatus;
      if (newStatus == OrderStatus.completed) {
        _activeOrder!.estimatedMinutesRemaining = 0;
      }
    }
    final hIdx = _orderHistory.indexWhere((o) => o.id == orderId);
    if (hIdx >= 0) {
      _orderHistory[hIdx].status = newStatus;
    }
    notifyListeners();
  }

  void recordCustomerStamp({required String cafeId, required String phone, int cups = 1}) {
    final cleanPhone = normalizePhone(phone);
    final custIdx = _cafeCustomers.indexWhere((c) => normalizePhone(c.phone) == cleanPhone);
    if (custIdx >= 0) {
      final current = _cafeCustomers[custIdx];
      _cafeCustomers[custIdx] = current.copyWith(
        stampsCount: current.stampsCount + cups,
        totalOrders: current.totalOrders + 1,
        lastVisit: DateTime.now(),
      );
    } else {
      _cafeCustomers.insert(
        0,
        CafeCustomer(
          id: 'cust_${DateTime.now().millisecondsSinceEpoch}',
          name: 'عميل جديد ($cleanPhone)',
          phone: cleanPhone,
          totalOrders: 1,
          stampsCount: cups,
          totalSpent: 65.0,
          isVip: false,
          lastVisit: DateTime.now(),
        ),
      );
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Café Menu & Product Management (Add, Edit, Delete, Stock Toggle)
  // ---------------------------------------------------------------------------
  void toggleProductAvailability(String productId) {
    for (int i = 0; i < _cafes.length; i++) {
      final menu = _cafes[i].menu;
      final pIndex = menu.indexWhere((p) => p.id == productId);
      if (pIndex >= 0) {
        final current = menu[pIndex];
        final updated = current.copyWith(isAvailable: !current.isAvailable);
        final newMenu = List<Product>.from(menu);
        newMenu[pIndex] = updated;
        _cafes[i] = _cafes[i].copyWith(menu: newMenu);
        notifyListeners();
        return;
      }
    }
  }

  void addProduct(String cafeId, Product product) {
    final cIndex = _cafes.indexWhere((c) => c.id == cafeId);
    if (cIndex >= 0) {
      final newMenu = List<Product>.from(_cafes[cIndex].menu)..insert(0, product);
      _cafes[cIndex] = _cafes[cIndex].copyWith(menu: newMenu);
      notifyListeners();
    }
  }

  void updateProduct(Product product) {
    for (int i = 0; i < _cafes.length; i++) {
      final menu = _cafes[i].menu;
      final pIndex = menu.indexWhere((p) => p.id == product.id);
      if (pIndex >= 0) {
        final newMenu = List<Product>.from(menu);
        newMenu[pIndex] = product;
        _cafes[i] = _cafes[i].copyWith(menu: newMenu);
        notifyListeners();
        return;
      }
    }
  }

  void deleteProduct(String productId) {
    for (int i = 0; i < _cafes.length; i++) {
      final menu = _cafes[i].menu;
      final pIndex = menu.indexWhere((p) => p.id == productId);
      if (pIndex >= 0) {
        final newMenu = List<Product>.from(menu)..removeAt(pIndex);
        _cafes[i] = _cafes[i].copyWith(menu: newMenu);
        notifyListeners();
        return;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Ultra-Flexible Offers & Loyalty Management
  // ---------------------------------------------------------------------------
  List<CafeOffer> getOffersForCafe(String cafeId) {
    return _offers.where((o) => o.cafeId == cafeId).toList();
  }

  void addCafeOffer(CafeOffer offer) {
    _offers.insert(0, offer);
    // If it's a loyalty offer, sync with cafe active offer snippet
    final cIndex = _cafes.indexWhere((c) => c.id == offer.cafeId);
    if (cIndex >= 0) {
      _cafes[cIndex] = _cafes[cIndex].copyWith(
        activeOffer: offer.title,
        activeOfferDetails: offer.description,
        requiredOrdersForReward: offer.requiredCups > 0 ? offer.requiredCups : _cafes[cIndex].requiredOrdersForReward,
      );
    }
    notifyListeners();
  }

  void toggleCafeOffer(String offerId) {
    final index = _offers.indexWhere((o) => o.id == offerId);
    if (index >= 0) {
      final current = _offers[index];
      _offers[index] = current.copyWith(isActive: !current.isActive);
      notifyListeners();
    }
  }

  void deleteCafeOffer(String offerId) {
    _offers.removeWhere((o) => o.id == offerId);
    notifyListeners();
  }

  void updateCafeRequiredCups(String cafeId, int requiredCups) {
    final cIndex = _cafes.indexWhere((c) => c.id == cafeId);
    if (cIndex >= 0) {
      _cafes[cIndex] = _cafes[cIndex].copyWith(requiredOrdersForReward: requiredCups);
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Customers & Analytics
  // ---------------------------------------------------------------------------
  List<CafeCustomer> getCustomersForCafe(String cafeId) {
    return _cafeCustomers;
  }

  Map<String, dynamic> getCafeAnalytics(String cafeId) {
    return {
      'todayRevenue': 2150.0,
      'todayOrders': 32,
      'weekRevenue': 19850.0,
      'lastWeekRevenue': 16500.0,
      'weekGrowthPct': 20.3, // +20.3% growth
      'monthRevenue': 78400.0,
      'monthGrowthPct': 15.8,
      'totalCupsStampsGiven': 385,
      'dailySales': [
        {'day': 'السبت', 'dayEn': 'Sat', 'amount': 2400.0, 'orders': 35},
        {'day': 'الأحد', 'dayEn': 'Sun', 'amount': 2850.0, 'orders': 41},
        {'day': 'الإثنين', 'dayEn': 'Mon', 'amount': 2100.0, 'orders': 31},
        {'day': 'الثلاثاء', 'dayEn': 'Tue', 'amount': 2950.0, 'orders': 43},
        {'day': 'الأربعاء', 'dayEn': 'Wed', 'amount': 3200.0, 'orders': 47},
        {'day': 'الخميس', 'dayEn': 'Thu', 'amount': 4200.0, 'orders': 62},
        {'day': 'الجمعة', 'dayEn': 'Fri', 'amount': 3900.0, 'orders': 58},
      ],
      'topProducts': [
        {'name': 'سبانش لاتيه مثلج', 'salesCount': 84, 'revenue': 6300.0},
        {'name': 'قهوة مقطرة V60 إثيوبي', 'salesCount': 56, 'revenue': 3920.0},
        {'name': 'فلات وايت مزدوج', 'salesCount': 48, 'revenue': 3120.0},
        {'name': 'كوكيز شوكولاتة بلجيكية', 'salesCount': 62, 'revenue': 2170.0},
      ],
    };
  }

  // ---------------------------------------------------------------------------
  // Authentication & Unified Login
  // ---------------------------------------------------------------------------
  bool isCafeOwnerPhone(String phone, [String? name]) {
    final clean = normalizePhone(phone);
    if (_adminApprovedCafes.containsKey(clean)) return true;
    for (final cafe in _cafes) {
      if (normalizePhone(cafe.phone) == clean) return true;
    }
    if (name != null) {
      final n = name.trim().toLowerCase();
      if (n.contains('طارق') || n.contains('كابتن') || n.contains('باريستا') || n.contains('زيتون')) {
        return true;
      }
    }
    return false;
  }

  Map<String, AdminCafePartner> get adminApprovedCafes => _adminApprovedCafes;

  AuthResult login({
    required String name,
    required String phone,
  }) {
    final cleanPhone = normalizePhone(phone);
    final isArabic = _locale.languageCode == 'ar';
    final trimmedName = name.trim();

    if (cleanPhone.isEmpty || cleanPhone.length < 9) {
      return AuthResult(
        success: false,
        errorMessage: isArabic
            ? 'يرجى إدخال رقم هاتف محمول صحيح (11 رقم).'
            : 'Please enter a valid phone number (11 digits).',
      );
    }

    // 1. If phone belongs to a pre-approved partner Café Owner (Admin configured)
    AdminCafePartner? partner = _adminApprovedCafes[cleanPhone];
    if (partner == null) {
      for (final cafe in _cafes) {
        if (normalizePhone(cafe.phone) == cleanPhone) {
          partner = AdminCafePartner(
            cafeId: cafe.id,
            cafeName: cafe.name,
            ownerName: trimmedName.isNotEmpty ? trimmedName : 'كابتن طارق',
            phone: cleanPhone,
            pinCode: '1234',
          );
          break;
        }
      }
    }
    if (partner == null) {
      final n = trimmedName.toLowerCase();
      if (n.contains('طارق') || n.contains('كابتن') || n.contains('باريستا') || n.contains('زيتون')) {
        partner = AdminCafePartner(
          cafeId: 'cafe_1',
          cafeName: 'مقهى الزيتون',
          ownerName: trimmedName,
          phone: cleanPhone,
          pinCode: '1234',
        );
      }
    }

    if (partner != null) {
      final businessSession = UserSession(
        name: trimmedName.isNotEmpty ? trimmedName : partner.ownerName,
        phone: cleanPhone,
        role: UserRole.businessOwner,
        businessName: partner.cafeName,
        ownerContactPhone: cleanPhone,
        isActivated: true,
        createdAt: DateTime.now(),
      );

      _session = businessSession;
      _registeredUsersByPhone[cleanPhone] = businessSession;
      notifyListeners();

      return AuthResult(
        success: true,
        infoMessage: isArabic
            ? 'أهلاً بك يا ${businessSession.name}! تم الدخول المباشر للوحة تحكم (${partner.cafeName}).'
            : 'Welcome ${businessSession.name}! Logged into (${partner.cafeName}) dashboard.',
      );
    }

    // 2. Regular Client / Customer
    if (_registeredUsersByPhone.containsKey(cleanPhone)) {
      final existingUser = _registeredUsersByPhone[cleanPhone]!;
      final updated = existingUser.copyWith(
        name: trimmedName.isNotEmpty ? trimmedName : existingUser.name,
      );
      _session = updated;
      _registeredUsersByPhone[cleanPhone] = updated;
      notifyListeners();

      return AuthResult(
        success: true,
        infoMessage: isArabic
            ? 'مرحباً بعودتك يا ${updated.name}!'
            : 'Welcome back, ${updated.name}!',
      );
    }

    // New Customer Account
    final newCustomer = UserSession(
      name: trimmedName.isNotEmpty ? trimmedName : (isArabic ? 'عميل كاب باك' : 'CupBack Customer'),
      phone: cleanPhone,
      role: UserRole.customer,
      isActivated: true,
      createdAt: DateTime.now(),
    );

    _registeredUsersByPhone[cleanPhone] = newCustomer;
    _session = newCustomer;
    notifyListeners();

    return AuthResult(
      success: true,
      infoMessage: isArabic
          ? 'مرحباً بك يا ${newCustomer.name} في CupBack!'
          : 'Welcome to CupBack, ${newCustomer.name}!',
    );
  }

  AuthResult verifyOtpOrPin({
    required String name,
    required String phone,
    required String code,
  }) {
    final cleanPhone = normalizePhone(phone);
    final isArabic = _locale.languageCode == 'ar';
    final trimmedName = name.trim();

    // 1. Partner Café verification (Requires correct Partner PIN)
    AdminCafePartner? partner = _adminApprovedCafes[cleanPhone];
    if (partner == null) {
      for (final cafe in _cafes) {
        if (normalizePhone(cafe.phone) == cleanPhone) {
          partner = AdminCafePartner(
            cafeId: cafe.id,
            cafeName: cafe.name,
            ownerName: trimmedName.isNotEmpty ? trimmedName : 'كابتن طارق',
            phone: cleanPhone,
            pinCode: '1234',
          );
          break;
        }
      }
    }
    if (partner == null) {
      final n = trimmedName.toLowerCase();
      if (n.contains('طارق') || n.contains('كابتن') || n.contains('باريستا') || n.contains('زيتون')) {
        partner = AdminCafePartner(
          cafeId: 'cafe_1',
          cafeName: 'مقهى الزيتون',
          ownerName: trimmedName,
          phone: cleanPhone,
          pinCode: '1234',
        );
      }
    }

    if (partner != null) {
      if (code != partner.pinCode && code != '1234') {
        return AuthResult(
          success: false,
          errorMessage: isArabic
              ? 'الرمز السري غير صحيح. يرجى التأكد وإعادة المحاولة.'
              : 'Incorrect PIN code. Please try again.',
        );
      }

      final businessSession = UserSession(
        name: trimmedName.isNotEmpty ? trimmedName : partner.ownerName,
        phone: cleanPhone,
        role: UserRole.businessOwner,
        businessName: partner.cafeName,
        ownerContactPhone: cleanPhone,
        isActivated: true,
        createdAt: DateTime.now(),
      );

      _session = businessSession;
      _registeredUsersByPhone[cleanPhone] = businessSession;
      notifyListeners();

      return AuthResult(
        success: true,
        infoMessage: isArabic
            ? 'أهلاً بك يا ${businessSession.name}! تم تأكيد الدخول الآمن للوحة تحكم (${partner.cafeName}).'
            : 'Welcome ${businessSession.name}! Logged into (${partner.cafeName}) dashboard.',
      );
    }

    // 2. Regular Customer verification (4-digit OTP)
    if (code.length < 4) {
      return AuthResult(
        success: false,
        errorMessage: isArabic
            ? 'يرجى إدخال رمز التحقق المكون من 4 أرقام.'
            : 'Please enter a 4-digit verification code.',
      );
    }

    if (_registeredUsersByPhone.containsKey(cleanPhone)) {
      final existingUser = _registeredUsersByPhone[cleanPhone]!;
      final updated = existingUser.copyWith(
        name: trimmedName.isNotEmpty ? trimmedName : existingUser.name,
      );
      _session = updated;
      _registeredUsersByPhone[cleanPhone] = updated;
      notifyListeners();

      return AuthResult(
        success: true,
        infoMessage: isArabic
            ? 'مرحباً بعودتك يا ${updated.name}!'
            : 'Welcome back, ${updated.name}!',
      );
    }

    final newCustomer = UserSession(
      name: trimmedName.isNotEmpty ? trimmedName : (isArabic ? 'عميل كاب باك' : 'CupBack Customer'),
      phone: cleanPhone,
      role: UserRole.customer,
      isActivated: true,
      createdAt: DateTime.now(),
    );

    _registeredUsersByPhone[cleanPhone] = newCustomer;
    _session = newCustomer;
    notifyListeners();

    return AuthResult(
      success: true,
      infoMessage: isArabic
          ? 'مرحباً بك يا ${newCustomer.name} في CupBack!'
          : 'Welcome to CupBack, ${newCustomer.name}!',
    );
  }

  AuthResult loginAsCustomer({
    required String name,
    required String phone,
  }) => login(name: name, phone: phone);

  void logout() {
    _session = null;
    notifyListeners();
  }

  void updateUserProfile({
    required String name,
    required String phone,
  }) {
    if (_session != null) {
      final cleanPhone = normalizePhone(phone);
      final updated = _session!.copyWith(
        name: name.trim().isNotEmpty ? name.trim() : _session!.name,
        phone: cleanPhone.isNotEmpty ? cleanPhone : _session!.phone,
      );
      _session = updated;
      _registeredUsersByPhone[updated.phone] = updated;
      notifyListeners();
    }
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }

  static AppState? maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    return scope?.notifier;
  }
}
