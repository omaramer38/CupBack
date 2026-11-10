import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/state/app_state.dart';
import '../core/models/cafe.dart';
import '../core/models/cart_item.dart';
import '../core/widgets/fade_slide_transition.dart';
import '../core/widgets/pressable_scale.dart';
import '../core/widgets/bouncing_cart_badge.dart';
import '../core/widgets/rating_modal.dart';
import 'cart_screen.dart';
import 'product_details_screen.dart';

class CafeDetailsScreen extends StatefulWidget {
  final Cafe cafe;

  const CafeDetailsScreen({super.key, required this.cafe});

  @override
  State<CafeDetailsScreen> createState() => _CafeDetailsScreenState();
}

class _CafeDetailsScreenState extends State<CafeDetailsScreen> {
  String _selectedCategory = 'الكل';
  late final PageController _galleryPageController;
  int _currentGalleryIndex = 0;

  @override
  void initState() {
    super.initState();
    _galleryPageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _galleryPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = appState.strings;
    final isArabic = strings.isArabic;
    final cafe = appState.cafes.firstWhere((c) => c.id == widget.cafe.id, orElse: () => widget.cafe);
    final gallery = cafe.gallery;
    final reviews = appState.getReviewsForCafe(cafe.id);

    final isFav = appState.isFavorite(cafe.id);
    final orderCount = appState.getOrdersCountForCafe(cafe.id);
    final remainingOrders = appState.getRemainingOrdersForReward(cafe.id);

    // Filter categories from menu
    final categories = ['الكل', ...cafe.menu.map((p) => p.category).toSet()];
    final filteredMenu = _selectedCategory == 'الكل'
        ? cafe.menu
        : cafe.menu.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Cover & App Bar with Hero Image
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.deepRoast,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PressableScale(
                    scaleFactor: 0.90,
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PressableScale(
                      scaleFactor: 0.90,
                      onTap: () {
                        appState.toggleFavorite(cafe.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFav
                                  ? (isArabic ? 'تمت إزالة الكافيه من المفضلة' : 'Removed from favorites')
                                  : (isArabic ? 'تمت إضافة الكافيه إلى المفضلة ❤️' : 'Added to favorites ❤️'),
                            ),
                            backgroundColor: AppColors.deepRoast,
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? AppColors.error : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (cafe.image != null && cafe.image!.isNotEmpty)
                        Image.network(
                          cafe.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFF1B110B),
                            child: const Center(
                              child: Icon(Icons.coffee_rounded, size: 60, color: Colors.white24),
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1B110B), Color(0xFF3E2316)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.coffee_rounded,
                              size: 80,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.25),
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 20,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cafe.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${cafe.location} • ${cafe.distance}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: cafe.isOpen ? AppColors.success : AppColors.error,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                cafe.isOpen
                                    ? (isArabic ? 'مفتوح الآن' : 'Open')
                                    : (isArabic ? 'مغلق' : 'Closed'),
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Cafe-Specific Loyalty Status & Active Offer Card
              SliverToBoxAdapter(
                child: FadeSlideTransition(
                  delay: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Container(
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
                          // 2.1 Title and Collected Cups Pill
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: AppColors.caramelAccent.withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.loyalty_rounded,
                                      color: AppColors.caramelAccent,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isArabic ? 'بطاقة ولاء ${cafe.name}' : '${cafe.name} Loyalty',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.deepRoast,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F4EE),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFE8E0D5)),
                                ),
                                child: Text(
                                  '${orderCount % cafe.requiredOrdersForReward} / ${cafe.requiredOrdersForReward} ${isArabic ? 'أكواب' : 'cups'}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.deepRoast,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // 2.2 Visual Stamp Cups Row
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF8F5),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFEFE8DE)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(cafe.requiredOrdersForReward, (cupIdx) {
                                final isFilled = cupIdx < (orderCount % cafe.requiredOrdersForReward);
                                final isLastSlot = cupIdx == cafe.requiredOrdersForReward - 1;

                                return Column(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: isFilled
                                            ? AppColors.deepRoast
                                            : (isLastSlot ? const Color(0xFFFFF3E0) : Colors.white),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isFilled
                                              ? AppColors.deepRoast
                                              : (isLastSlot ? AppColors.caramelAccent : const Color(0xFFE2D7CB)),
                                          width: 1.5,
                                        ),
                                        boxShadow: isFilled
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.deepRoast.withValues(alpha: 0.15),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Center(
                                        child: isFilled
                                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                                            : (isLastSlot
                                                ? const Icon(Icons.card_giftcard_rounded, color: AppColors.caramelAccent, size: 16)
                                                : const Icon(Icons.coffee_rounded, color: Color(0xFFC7B8A8), size: 16)),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${cupIdx + 1}',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: isFilled ? AppColors.deepRoast : const Color(0xFFB0A296),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // 2.3 Prominent Countdown Highlight (فاضلي كام كوب ع الخصم)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF6EE),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.caramelAccent.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.local_fire_department_rounded,
                                  color: AppColors.caramelAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isArabic
                                            ? 'طلبت $orderCount أوردرات • فاضلك $remainingOrders ${remainingOrders == 1 ? 'كوب' : (remainingOrders == 2 ? 'كوبين' : 'أكواب')} فقط!'
                                            : 'Ordered $orderCount times • Just $remainingOrders more ${remainingOrders == 1 ? 'cup' : 'cups'} left!',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.deepRoast,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        isArabic
                                            ? 'أكمل ${cafe.requiredOrdersForReward} أكواب لتستلم كوبك القادم مجاناً أو بخصم خاص 🎁'
                                            : 'Complete ${cafe.requiredOrdersForReward} cups to claim your free reward 🎁',
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          color: AppColors.coffeeMuted,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // 2.4 Active Offer snippet
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.stars_rounded, color: AppColors.caramelAccent, size: 17),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${isArabic ? 'العرض الساري:' : 'Offer:'} ${cafe.activeOffer}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.deepRoast,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 2.5 Animated Gallery Carousel (أجواء ومعرض صور الكافيه)
              if (gallery.isNotEmpty)
                SliverToBoxAdapter(
                  child: FadeSlideTransition(
                    delay: const Duration(milliseconds: 130),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.photo_library_rounded, color: AppColors.caramelAccent, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      isArabic ? 'معرض صور وأجواء الكافيه' : 'Café Atmosphere & Gallery',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.deepRoast,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBF6EE),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.bolt_rounded, size: 13, color: AppColors.success),
                                      const SizedBox(width: 3),
                                      Text(
                                        isArabic ? 'مضغوطة وسريعة' : 'Compressed & Fast',
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 175,
                            child: PageView.builder(
                              controller: _galleryPageController,
                              onPageChanged: (idx) {
                                setState(() => _currentGalleryIndex = idx);
                              },
                              itemCount: gallery.length,
                              itemBuilder: (context, index) {
                                final isCurrent = index == _currentGalleryIndex;
                                return AnimatedScale(
                                  scale: isCurrent ? 1.0 : 0.93,
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeOutCubic,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: isCurrent ? 0.14 : 0.06),
                                          blurRadius: isCurrent ? 10 : 4,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            gallery[index],
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              color: const Color(0xFF2C1810),
                                              child: const Center(
                                                child: Icon(Icons.coffee, color: Colors.white38, size: 40),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withValues(alpha: 0.55),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            right: 12,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.65),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                '${index + 1} / ${gallery.length}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(gallery.length, (idx) {
                              final active = idx == _currentGalleryIndex;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: active ? 18 : 6,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: active ? AppColors.caramelAccent : const Color(0xFFDCD2C7),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // 3. Category Filter Chips
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
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = _selectedCategory == cat;
                        return PressableScale(
                          scaleFactor: 0.94,
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
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
                              cat,
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

              // 4. Products Menu List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredMenu[index];
                      final cartItem = appState.cart.firstWhere(
                        (item) => item.product.id == product.id,
                        orElse: () => CartItem(product: product, quantity: 0),
                      );
                      final inCart = cartItem.quantity > 0;

                      return FadeSlideTransition(
                        delay: Duration(milliseconds: 180 + (index * 40)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PressableScale(
                            scaleFactor: 0.98,
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
                                  // Hero Image
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
                                                errorBuilder: (context, error, stackTrace) => const Center(
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
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          product.description,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.coffeeMuted,
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${product.price.toStringAsFixed(0)} ج.م',
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.caramelAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Add / Stepper
                                  if (!inCart)
                                    PressableScale(
                                      scaleFactor: 0.90,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProductDetailsScreen(product: product, cafe: cafe),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.deepRoast,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          isArabic ? '+ أضف' : '+ Add',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1EBE2),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          PressableScale(
                                            scaleFactor: 0.85,
                                            onTap: () => appState.updateCartQuantity(product.id, -1),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Icon(Icons.remove, size: 16, color: AppColors.deepRoast),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              '${cartItem.quantity}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: AppColors.deepRoast,
                                              ),
                                            ),
                                          ),
                                          PressableScale(
                                            scaleFactor: 0.85,
                                            onTap: () => appState.updateCartQuantity(product.id, 1),
                                            child: const Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Icon(Icons.add, size: 16, color: AppColors.deepRoast),
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
                      );
                    },
                    childCount: filteredMenu.length,
                  ),
                ),
              ),

              // 4.5 Customer Reviews & Ratings Section (آراء وتقييمات العملاء)
              SliverToBoxAdapter(
                child: FadeSlideTransition(
                  delay: const Duration(milliseconds: 220),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reviews Header with Average Rating & Write Review CTA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic ? 'آراء وتقييمات العملاء' : 'Customer Reviews',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.deepRoast,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${cafe.rating.toStringAsFixed(1)} (${cafe.reviewsCount} ${isArabic ? 'تقييم' : 'reviews'})',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.deepRoast,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            PressableScale(
                              scaleFactor: 0.92,
                              onTap: () {
                                RatingModal.showForCafe(
                                  context,
                                  cafeId: cafe.id,
                                  cafeName: cafe.name,
                                  onSubmitted: () => setState(() {}),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: AppColors.deepRoast,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.rate_review_rounded, color: Colors.white, size: 14),
                                    const SizedBox(width: 5),
                                    Text(
                                      isArabic ? '+ قيّم الآن' : '+ Rate Café',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        if (reviews.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFECE6DD)),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFFC7B8A8), size: 36),
                                const SizedBox(height: 8),
                                Text(
                                  isArabic ? 'كن أول من يقيّم هذا الكافيه!' : 'Be the first to review this café!',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepRoast,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...reviews.map((rev) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFECE6DD)),
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
                                            CircleAvatar(
                                              radius: 14,
                                              backgroundColor: AppColors.caramelAccent.withValues(alpha: 0.15),
                                              child: Text(
                                                rev.customerName.isNotEmpty ? rev.customerName[0] : 'ع',
                                                style: const TextStyle(
                                                  color: AppColors.caramelDark,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              rev.customerName,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.deepRoast,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          isArabic ? rev.timeAgoAr : rev.timeAgoEn,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.coffeeMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: List.generate(5, (sIdx) {
                                        return Icon(
                                          sIdx < rev.rating.round()
                                              ? Icons.star_rounded
                                              : Icons.star_border_rounded,
                                          color: const Color(0xFFF59E0B),
                                          size: 16,
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      rev.comment,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.deepRoast,
                                        height: 1.35,
                                      ),
                                    ),
                                    if (rev.tags.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: rev.tags.map((tag) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF7F4EE),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              tag,
                                              style: const TextStyle(
                                                fontSize: 10.5,
                                                color: AppColors.coffeeMuted,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),

          // 5. Floating Bottom Cart Bar (Appears when items are in cart)
          if (appState.cart.isNotEmpty)
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
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
                    borderRadius: BorderRadius.circular(22),
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
                      BouncingBadge(
                        count: appState.cartTotalItems,
                        badgeColor: AppColors.caramelAccent,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isArabic ? 'عرض السلة وإتمام الطلب' : 'View Cart & Checkout',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${appState.cartSubtotal.toStringAsFixed(0)} ج.م',
                        style: const TextStyle(
                          color: AppColors.caramelLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white70),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
