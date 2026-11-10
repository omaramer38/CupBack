import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/state/app_state.dart';
import '../core/widgets/fade_slide_transition.dart';
import '../core/widgets/pressable_scale.dart';
import 'cafe_details_screen.dart';

class CafesScreen extends StatefulWidget {
  const CafesScreen({super.key});

  @override
  State<CafesScreen> createState() => _CafesScreenState();
}

class _CafesScreenState extends State<CafesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'الكل';

  final List<String> _filtersAr = [
    'الكل',
    'المفضلة ❤️',
    'مفتوح الآن',
    'قهوة مختصة',
    'إسبريسو',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = appState.strings;
    final isArabic = strings.isArabic;
    final cafes = appState.cafes;

    // Filter logic
    final filteredCafes = cafes.where((cafe) {
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.trim().toLowerCase();
        final matchesName = cafe.name.toLowerCase().contains(query) || cafe.nameEn.toLowerCase().contains(query);
        final matchesLocation = cafe.location.toLowerCase().contains(query);
        final matchesDrink = cafe.menu.any((p) => p.name.toLowerCase().contains(query));
        if (!matchesName && !matchesLocation && !matchesDrink) {
          return false;
        }
      }

      if (_selectedFilter == 'المفضلة ❤️') {
        return appState.isFavorite(cafe.id);
      }
      if (_selectedFilter == 'مفتوح الآن') {
        return cafe.isOpen;
      }
      if (_selectedFilter == 'قهوة مختصة') {
        return cafe.category.contains('مختصة') || cafe.menu.any((p) => p.category.contains('مختصة'));
      }
      if (_selectedFilter == 'إسبريسو') {
        return cafe.category.contains('إسبريسو');
      }

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Top Header Bar (Title + Subtitle + Notification Bell)
            SliverToBoxAdapter(
              child: FadeSlideTransition(
                delay: const Duration(milliseconds: 50),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'دليل المقاهي الشريكة' : 'Partner Cafés Guide',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 19,
                              color: AppColors.deepRoast,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isArabic
                                ? 'اجمع أكوابك واحصل على مشروبك المجاني'
                                : 'Collect your cups & earn free drinks',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.coffeeMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      PressableScale(
                        scaleFactor: 0.92,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isArabic
                                    ? 'لديك إشعار جديد: عروض المقاهي الشريكة سارية اليوم!'
                                    : 'Partner cafes offers are active today!',
                              ),
                              backgroundColor: AppColors.deepRoast,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFF0ECE4)),
                            boxShadow: AppDecorations.softCardShadow,
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.deepRoast,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Compact Search Input Bar
            SliverToBoxAdapter(
              child: FadeSlideTransition(
                delay: const Duration(milliseconds: 90),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF0ECE4), width: 1),
                      boxShadow: AppDecorations.softCardShadow,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: AppColors.caramelAccent,
                          size: 21,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepRoast,
                            ),
                            decoration: InputDecoration(
                              hintText: isArabic
                                  ? 'ابحث باسم الكافيه، أو الموقع...'
                                  : 'Search by café, or location...',
                              hintStyle: const TextStyle(
                                fontSize: 12,
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
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            child: const Icon(Icons.close_rounded, size: 18, color: AppColors.coffeeMuted),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. Category Filter Chips (Sliding Pills)
            SliverToBoxAdapter(
              child: FadeSlideTransition(
                delay: const Duration(milliseconds: 130),
                child: SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filtersAr.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = _filtersAr[index];
                      final isSelected = _selectedFilter == filter;
                      return PressableScale(
                        scaleFactor: 0.94,
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.deepRoast : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.deepRoast : const Color(0xFFF0ECE4),
                            ),
                            boxShadow: isSelected ? AppDecorations.softCardShadow : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            filter,
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

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // 4. Cafes Feed List
            if (filteredCafes.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.coffee_outlined, size: 48, color: AppColors.coffeeMuted),
                        const SizedBox(height: 10),
                        Text(
                          isArabic ? 'لم يتم العثور على مقاهٍ مطابقة' : 'No cafés found',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.deepRoast),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cafe = filteredCafes[index];
                      final isFav = appState.isFavorite(cafe.id);
                      final orderCount = appState.getOrdersCountForCafe(cafe.id);
                      final requiredOrders = cafe.requiredOrdersForReward;
                      final remaining = appState.getRemainingOrdersForReward(cafe.id);
                      final progressCups = orderCount % requiredOrders;
                      final isRewardUnlocked = remaining == 0 && orderCount > 0;

                      return FadeSlideTransition(
                        delay: Duration(milliseconds: 150 + (index * 45)),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PressableScale(
                            scaleFactor: 0.98,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CafeDetailsScreen(cafe: cafe),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: const Color(0xFFF0ECE4), width: 1),
                                boxShadow: AppDecorations.softCardShadow,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // --- Top Section: Compact Side Thumbnail + Details ---
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Side Thumbnail (72x72)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          width: 72,
                                          height: 72,
                                          color: const Color(0xFFF7F4EE),
                                          child: cafe.image != null && cafe.image!.isNotEmpty
                                              ? Image.network(
                                                  cafe.image!,
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

                                      const SizedBox(width: 12),

                                      // Details Column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Name + Open Status + Favorite Heart
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          cafe.name,
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w900,
                                                            color: AppColors.deepRoast,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      // Soft Status Pill (Mint for open, Blush for closed)
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: cafe.isOpen
                                                              ? const Color(0xFFEBF7EE)
                                                              : const Color(0xFFFDF0ED),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          cafe.isOpen
                                                              ? (isArabic ? 'مفتوح' : 'Open')
                                                              : (isArabic ? 'مغلق' : 'Closed'),
                                                          style: TextStyle(
                                                            color: cafe.isOpen
                                                                ? const Color(0xFF2B833A)
                                                                : const Color(0xFFC94332),
                                                            fontSize: 9.5,
                                                            fontWeight: FontWeight.w800,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // Favorite Heart Button
                                                PressableScale(
                                                  scaleFactor: 0.85,
                                                  onTap: () {
                                                    appState.toggleFavorite(cafe.id);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4),
                                                    child: Icon(
                                                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                                      color: isFav ? const Color(0xFFF43F5E) : const Color(0xFFB0A296),
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 3),

                                            // Location
                                            Text(
                                              cafe.location,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.coffeeMuted,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            const SizedBox(height: 4),

                                            // Offer Tag (Tag icon + active offer in warm caramel)
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.local_offer_outlined,
                                                  size: 13,
                                                  color: AppColors.caramelAccent,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    cafe.activeOffer,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w800,
                                                      color: AppColors.caramelAccent,
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

                                  // --- Bottom Section: Cups Progress Bar ---
                                  const SizedBox(height: 10),
                                  const Divider(height: 1, thickness: 0.8, color: Color(0xFFF0ECE4)),
                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Visual Cups Row
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(requiredOrders, (cupIdx) {
                                          final isFilled = cupIdx < progressCups;
                                          final isLastSlot = cupIdx == requiredOrders - 1;

                                          return Container(
                                            margin: const EdgeInsets.only(left: 5),
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: isFilled
                                                  ? AppColors.deepRoast
                                                  : (isLastSlot
                                                      ? const Color(0xFFFBF2EA)
                                                      : const Color(0xFFFAF7F2)),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isFilled
                                                    ? AppColors.deepRoast
                                                    : (isLastSlot
                                                        ? AppColors.caramelAccent.withValues(alpha: 0.7)
                                                        : const Color(0xFFE2D7CB)),
                                                width: 1.2,
                                              ),
                                              boxShadow: isFilled
                                                  ? [
                                                      BoxShadow(
                                                        color: AppColors.deepRoast.withValues(alpha: 0.2),
                                                        blurRadius: 4,
                                                        offset: const Offset(0, 1.5),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: Center(
                                              child: isFilled
                                                  ? const Icon(Icons.coffee_rounded, color: Colors.white, size: 15)
                                                  : (isLastSlot
                                                      ? const Icon(Icons.card_giftcard_rounded, color: AppColors.caramelAccent, size: 14)
                                                      : const Icon(Icons.coffee_rounded, color: Color(0xFFC7B8A8), size: 14)),
                                            ),
                                          );
                                        }),
                                      ),

                                      // Remaining Count Badge Pill
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isRewardUnlocked
                                              ? const Color(0xFFEBF7EE)
                                              : (remaining == 1
                                                  ? const Color(0xFFFBF2EA)
                                                  : const Color(0xFFF7F4EE)),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          isRewardUnlocked
                                              ? (isArabic ? 'مشروب مجاني! 🎁' : 'Free Drink! 🎁')
                                              : (isArabic
                                                  ? 'باقي $remaining ${remaining == 1 ? 'طلب لكوب مجاني!' : (remaining == 2 ? 'طلبات' : 'طلبات')}'
                                                  : 'Left $remaining cups'),
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800,
                                            color: isRewardUnlocked
                                                ? const Color(0xFF2B833A)
                                                : (remaining == 1
                                                    ? AppColors.caramelAccent
                                                    : AppColors.deepRoast),
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
                      );
                    },
                    childCount: filteredCafes.length,
                  ),
                ),
              ),

            // Bottom clearance for floating navbar
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
    );
  }
}
