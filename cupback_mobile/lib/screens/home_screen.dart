import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/state/app_state.dart';
import '../core/models/cafe.dart';
import '../core/models/product.dart';
import '../core/models/order_model.dart';
import '../core/widgets/fade_slide_transition.dart';
import '../core/widgets/pressable_scale.dart';
import '../core/widgets/bouncing_cart_badge.dart';
import 'cafe_details_screen.dart';
import 'order_tracking_screen.dart';
import 'cart_screen.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToOffers;
  final VoidCallback onNavigateToRewards;

  const HomeScreen({
    super.key,
    required this.onNavigateToOffers,
    required this.onNavigateToRewards,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  String _selectedCity = 'كفر الشيخ';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categoriesAr = [
    '☕ الكل',
    '✨ قهوة مختصة',
    '❄️ مثلجات وكولد برو',
    '⚡ إسبريسو',
    '🥐 مخبوزات',
  ];

  final List<String> _categoriesEn = [
    '☕ All',
    '✨ Specialty V60',
    '❄️ Iced & Cold Brew',
    '⚡ Espresso',
    '🥐 Bakery',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCityPicker(BuildContext context, bool isArabic) {
    final cities = isArabic
        ? ['كفر الشيخ (المنطقة الحالية)', 'المنصورة (قريباً)', 'طنطا (قريباً)']
        : ['Kafr El Sheikh (Current)', 'Mansoura (Soon)', 'Tanta (Soon)'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5DDD3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isArabic ? 'اختر المدينة أو المنطقة' : 'Select City or Region',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepRoast,
                ),
              ),
              const SizedBox(height: 12),
              ...cities.map((city) {
                final isCurrent = city.contains('كفر الشيخ') || city.contains('Kafr El Sheikh');
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on_rounded,
                    color: isCurrent ? AppColors.caramelAccent : const Color(0xFF9E8B7E),
                  ),
                  title: Text(
                    city,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                      color: isCurrent ? AppColors.deepRoast : const Color(0xFF9E8B7E),
                      fontSize: 14,
                    ),
                  ),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.caramelAccent, size: 20)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCity = isArabic ? 'كفر الشيخ' : 'Kafr El Sheikh';
                    });
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeGreeting(String? userName, bool isArabic) {
    final hour = DateTime.now().hour;
    final isMorning = hour >= 5 && hour < 13;
    final prefix = isArabic
        ? (isMorning ? 'صباح الخير' : 'مساء الخير')
        : (isMorning ? 'Good morning' : 'Good evening');

    if (userName != null && userName.trim().isNotEmpty) {
      final firstName = userName.trim().split(' ').first;
      return '$prefix، $firstName ☕';
    }
    return '$prefix ☕';
  }

  void _quickAddToCart(Product product, Cafe cafe, AppState appState, bool isArabic) {
    appState.addToCart(
      product,
      cafe.name,
      quantity: 1,
      selectedSize: product.sizeOptions.first.name,
      selectedSweetness: product.sweetnessOptions.first,
      unitPrice: product.price,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isArabic
                    ? 'تمت إضافة ${product.name} إلى السلة ☕'
                    : 'Added ${product.name} to Cart ☕',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.deepRoast,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        action: SnackBarAction(
          label: isArabic ? 'السلة' : 'Cart',
          textColor: AppColors.caramelLight,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.maybeOf(context);
    final userName = appState?.session?.name;
    final isArabic = appState?.strings.isArabic ?? true;
    final activeOrder = appState?.activeOrder;
    final isOrderLive = activeOrder != null && activeOrder.status != OrderStatus.completed;
    final categories = isArabic ? _categoriesAr : _categoriesEn;

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Sleek Airy Header (HCI Simplified)
                SliverToBoxAdapter(
                  child: FadeSlideTransition(
                    delay: const Duration(milliseconds: 50),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                      child: Row(
                        children: [
                          // App Branding
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFECE6DD), width: 1),
                              boxShadow: AppDecorations.softCardShadow,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                'assets/images/cupback_logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.coffee_rounded,
                                  color: AppColors.deepRoast,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Location & Title
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CupBack',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.deepRoast,
                                    letterSpacing: 0.2,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                PressableScale(
                                  onTap: () => _showCityPicker(context, isArabic),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.location_on_rounded,
                                        size: 13,
                                        color: AppColors.caramelAccent,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        _selectedCity,
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.mediumRoast,
                                        ),
                                      ),
                                      const SizedBox(width: 1),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 15,
                                        color: AppColors.mediumRoast,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Cart Quick Button with Animated Bouncing Badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _buildTopIconButton(
                                icon: Icons.shopping_bag_outlined,
                                tooltip: isArabic ? 'سلة الطلبات' : 'Cart',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CartScreen()),
                                  );
                                },
                              ),
                              if (appState != null && appState.cartTotalItems > 0)
                                Positioned(
                                  top: -3,
                                  right: -3,
                                  child: BouncingBadge(count: appState.cartTotalItems),
                                ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          // Notifications
                          _buildTopIconButton(
                            icon: Icons.notifications_none_rounded,
                            tooltip: isArabic ? 'الإشعارات' : 'Notifications',
                            hasBadge: true,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabic
                                        ? 'لديك إشعار جديد: عرض 50% على ثاني كوب سارٍ اليوم!'
                                        : 'New offer: 50% off second cup active today!',
                                  ),
                                  backgroundColor: AppColors.deepRoast,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          // User Avatar
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF2ECE4),
                              border: Border.all(color: const Color(0xFFE4DAD0), width: 1.2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              (userName != null && userName.isNotEmpty) ? userName[0] : 'أ',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepRoast,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. Greeting & Search (Cleaned & De-cluttered)
                SliverToBoxAdapter(
                  child: FadeSlideTransition(
                    delay: const Duration(milliseconds: 100),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTimeGreeting(userName, isArabic),
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: AppColors.deepRoast,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Clean Search Bar
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFECE6DD), width: 1),
                              boxShadow: AppDecorations.softCardShadow,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded, color: AppColors.caramelAccent, size: 21),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (val) {
                                      setState(() {
                                        _searchQuery = val.trim();
                                      });
                                    },
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deepRoast,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: isArabic
                                          ? 'ابحث عن قهوة، كافيه، أو مشروب...'
                                          : 'Search coffee, cafe, or drink...',
                                      hintStyle: const TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF9E8B7E),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
                                    ),
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                    child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF9E8B7E)),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7F3ED),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.tune_rounded,
                                      size: 16,
                                      color: AppColors.deepRoast,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Category Filter Chips (Smooth Sliding Animation)
                SliverToBoxAdapter(
                  child: FadeSlideTransition(
                    delay: const Duration(milliseconds: 150),
                    child: SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final isSelected = _selectedCategoryIndex == index;
                          return PressableScale(
                            scaleFactor: 0.95,
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.deepRoast : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppColors.deepRoast : const Color(0xFFECE6DD),
                                ),
                                boxShadow: isSelected ? AppDecorations.softCardShadow : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                categories[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.deepRoast,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                // 4. Active Order Tracker Banner (Only if order is live & preparing)
                if (isOrderLive) ...[
                  SliverToBoxAdapter(
                    child: FadeSlideTransition(
                      delay: const Duration(milliseconds: 180),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PressableScale(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderTrackingScreen(order: activeOrder),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.caramelAccent.withValues(alpha: 0.5), width: 1.2),
                              boxShadow: AppDecorations.softCardShadow,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: AppColors.caramelAccent.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.access_time_filled_rounded, color: AppColors.caramelAccent, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${isArabic ? 'طلب نشط' : 'Active Order'} #${activeOrder.id} • ${activeOrder.cafeName}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                          color: AppColors.deepRoast,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${isArabic ? activeOrder.statusTextAr : activeOrder.statusTextEn} (${isArabic ? 'متبقي ${activeOrder.estimatedMinutesRemaining} د' : '${activeOrder.estimatedMinutesRemaining}m left'})',
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.caramelDark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.deepRoast,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isArabic ? 'تتبع ➔' : 'Track ➔',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                ],

                // 5. Hero Promotional Banner (Matching Reference Image 4)
                SliverToBoxAdapter(
                  child: FadeSlideTransition(
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PressableScale(
                        onTap: widget.onNavigateToOffers,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF221208),
                                Color(0xFF381B0D),
                                Color(0xFF4A2512),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF221208).withValues(alpha: 0.28),
                                blurRadius: 20,
                                offset: const Offset(0, 7),
                              ),
                            ],
                            border: Border.all(
                              color: AppColors.caramelAccent.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFECA062),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        isArabic ? 'عرض حصري اليوم' : 'TODAY ONLY',
                                        style: const TextStyle(
                                          color: Color(0xFF221208),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      isArabic ? 'خصم 50% على ثاني كوب' : '50% OFF Second Cup',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isArabic
                                          ? 'على جميع مشروبات اللاتيه والإسبريسو.'
                                          : 'On all iced lattes and espresso.',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            isArabic ? 'كود: CUP50' : 'CODE: CUP50',
                                            style: const TextStyle(
                                              color: Color(0xFFECA062),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Icons.copy_rounded,
                                            size: 12,
                                            color: Color(0xFFECA062),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Coffee Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  width: 90,
                                  height: 100,
                                  color: Colors.white.withValues(alpha: 0.08),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=400&auto=format&fit=crop&q=80',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.local_cafe_rounded, size: 40, color: Color(0xFFECA062)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // 6. Clean Loyalty Stamps Card (HCI Simplified)
                SliverToBoxAdapter(
                  child: FadeSlideTransition(
                    delay: const Duration(milliseconds: 250),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PressableScale(
                        onTap: widget.onNavigateToRewards,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xFFECE6DD), width: 1),
                            boxShadow: AppDecorations.softCardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: AppColors.caramelAccent.withValues(alpha: 0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.loyalty_rounded,
                                          color: AppColors.caramelAccent,
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isArabic ? 'بطاقة ولاء CupBack' : 'CupBack Rewards',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.deepRoast,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7F4EF),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFFE7DEC0)),
                                    ),
                                    child: const Text(
                                      '4 / 6 أكواب',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.deepRoast,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // Stamps Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStampSlot(1, isFilled: true),
                                  _buildStampDivider(isFilled: true),
                                  _buildStampSlot(2, isFilled: true),
                                  _buildStampDivider(isFilled: true),
                                  _buildStampSlot(3, isFilled: true),
                                  _buildStampDivider(isFilled: true),
                                  _buildStampSlot(4, isFilled: true),
                                  _buildStampDivider(isFilled: false),
                                  _buildStampSlot(5, isFilled: false),
                                  _buildStampDivider(isFilled: false),
                                  _buildStampSlot(6, isFilled: false, isRewardSlot: true),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Clean reward message
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F5EE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.card_giftcard_rounded,
                                      color: AppColors.caramelAccent,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        isArabic
                                            ? 'باقي كوبين فقط وتستلم كوبك القادم مجاناً!'
                                            : '2 more cups to claim your free reward!',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.deepRoast,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 10,
                                      color: AppColors.mediumRoast,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 18)),

                // 7. Featured Specialty Cafés Section Header
                SliverToBoxAdapter(
                  child: FadeSlideTransition(
                    delay: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isArabic ? 'المقاهي المميزة' : 'Featured Cafés',
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.deepRoast,
                            ),
                          ),
                          Text(
                            isArabic ? 'شركاء معتمدون' : 'Verified Partners',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.caramelAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // Horizontal Carousel of Cafes
                if (appState != null)
                  SliverToBoxAdapter(
                    child: FadeSlideTransition(
                      delay: const Duration(milliseconds: 320),
                      child: SizedBox(
                        height: 235,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: appState.cafes.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final cafe = appState.cafes[index];
                            return PressableScale(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CafeDetailsScreen(cafe: cafe),
                                  ),
                                );
                              },
                              child: _buildCafeCard(
                                cafe: cafe,
                                isArabic: isArabic,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 18)),

                // 8. Trending Drinks Section Header
                SliverToBoxAdapter(
                  child: FadeSlideTransition(
                    delay: const Duration(milliseconds: 360),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isArabic ? 'المشروبات الأكثر طلباً' : 'Trending Drinks',
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.deepRoast,
                            ),
                          ),
                          Text(
                            isArabic ? 'الأعلى تقييماً ⭐' : 'Top Rated ⭐',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFC87C43),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // 9. Trending Drinks List (Clean, High Quality Cards)
                if (appState != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildTrendingTile(
                            delayIndex: 0,
                            product: appState.cafes.first.menu[0],
                            cafe: appState.cafes.first,
                            isArabic: isArabic,
                            appState: appState,
                          ),
                          const SizedBox(height: 10),
                          _buildTrendingTile(
                            delayIndex: 1,
                            product: appState.cafes[1].menu[1],
                            cafe: appState.cafes[1],
                            isArabic: isArabic,
                            appState: appState,
                          ),
                          const SizedBox(height: 10),
                          _buildTrendingTile(
                            delayIndex: 2,
                            product: appState.cafes[3].menu[0],
                            cafe: appState.cafes[3],
                            isArabic: isArabic,
                            appState: appState,
                          ),
                          const SizedBox(height: 10),
                          _buildTrendingTile(
                            delayIndex: 3,
                            product: appState.cafes.first.menu[2],
                            cafe: appState.cafes.first,
                            isArabic: isArabic,
                            appState: appState,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Clearance for bottom floating navbar
                const SliverToBoxAdapter(child: SizedBox(height: 96)),
              ],
            ),
          ),

          // Floating Cart Indicator if items exist
          if (appState != null && appState.cart.isNotEmpty)
            Positioned(
              left: 20,
              right: 20,
              bottom: 84,
              child: PressableScale(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.deepRoast,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepRoast.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.caramelAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${appState.cartTotalItems}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isArabic ? 'السلة جاهزة للطلب' : 'Cart Ready',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      Text(
                        '${appState.cartSubtotal.toStringAsFixed(0)} ج.م',
                        style: const TextStyle(color: AppColors.caramelLight, fontWeight: FontWeight.w900, fontSize: 13.5),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 12),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrendingTile({
    required int delayIndex,
    required Product product,
    required Cafe cafe,
    required bool isArabic,
    required AppState appState,
  }) {
    return FadeSlideTransition(
      delay: Duration(milliseconds: 380 + (delayIndex * 60)),
      child: PressableScale(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(product: product, cafe: cafe),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFECE6DD), width: 1),
            boxShadow: AppDecorations.softCardShadow,
          ),
          child: Row(
            children: [
              // Hero Photo
              Hero(
                tag: 'product-img-${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 70,
                    height: 70,
                    color: const Color(0xFFF7F4EE),
                    child: product.image != null && product.image!.isNotEmpty
                        ? Image.network(
                            product.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.coffee_rounded, color: AppColors.deepRoast, size: 28),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.coffee_rounded, color: AppColors.deepRoast, size: 28),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepRoast,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cafe.name,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9E8B7E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 2),
                        Text(
                          '${cafe.rating}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepRoast,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• ${product.price.toStringAsFixed(0)} ج.م',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.caramelAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Circular Add Button
              PressableScale(
                scaleFactor: 0.90,
                onTap: () => _quickAddToCart(product, cafe, appState, isArabic),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.deepRoast,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepRoast.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool hasBadge = false,
  }) {
    return PressableScale(
      scaleFactor: 0.92,
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFECE6DD), width: 1),
          boxShadow: AppDecorations.softCardShadow,
        ),
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: AppColors.deepRoast, size: 20),
            if (hasBadge)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.caramelAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStampSlot(int index, {required bool isFilled, bool isRewardSlot = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isFilled
            ? AppColors.deepRoast
            : (isRewardSlot ? const Color(0xFFFFF3E0) : const Color(0xFFF7F4EE)),
        shape: BoxShape.circle,
        border: Border.all(
          color: isFilled
              ? AppColors.deepRoast
              : (isRewardSlot ? AppColors.caramelAccent : const Color(0xFFE2D7CB)),
          width: 1.2,
        ),
      ),
      child: Center(
        child: isFilled
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
            : (isRewardSlot
                ? const Icon(Icons.card_giftcard_rounded, color: AppColors.caramelAccent, size: 15)
                : Text(
                    '$index',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9E8B7E),
                    ),
                  )),
      ),
    );
  }

  Widget _buildStampDivider({required bool isFilled}) {
    return Container(
      width: 10,
      height: 2,
      decoration: BoxDecoration(
        color: isFilled ? AppColors.deepRoast : const Color(0xFFE4DAD0),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildCafeCard({
    required Cafe cafe,
    required bool isArabic,
  }) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECE6DD), width: 1),
        boxShadow: AppDecorations.softCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cafe Photo Header
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            child: SizedBox(
              height: 115,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (cafe.image != null && cafe.image!.isNotEmpty)
                    Image.network(
                      cafe.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF26150D),
                        child: const Icon(Icons.coffee_rounded, size: 36, color: Colors.white24),
                      ),
                    )
                  else
                    Container(
                      color: const Color(0xFF26150D),
                      child: const Icon(Icons.coffee_rounded, size: 36, color: Colors.white24),
                    ),
                  // Subtle top/bottom vignette
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.45),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Status badge
                  Positioned(
                    top: 8,
                    right: isArabic ? 8 : null,
                    left: isArabic ? null : 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: cafe.isOpen ? AppColors.success : AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        cafe.isOpen ? (isArabic ? 'مفتوح' : 'Open') : (isArabic ? 'مغلق' : 'Closed'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Star rating tag
                  Positioned(
                    top: 8,
                    left: isArabic ? 8 : null,
                    right: isArabic ? null : 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 2),
                          Text(
                            '${cafe.rating}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F4EE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          cafe.category,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepRoast,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (cafe.activeOffer.isNotEmpty)
                      Flexible(
                        child: Text(
                          cafe.activeOffer,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.caramelAccent,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  cafe.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.deepRoast,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.near_me_rounded,
                      size: 11,
                      color: Color(0xFF9E8B7E),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '${cafe.location} • ${cafe.distance}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF9E8B7E),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
