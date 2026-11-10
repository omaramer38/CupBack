import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/state/app_state.dart';
import '../core/models/cafe.dart';
import '../core/widgets/fade_slide_transition.dart';
import '../core/widgets/pressable_scale.dart';
import 'cafe_details_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedFilterIndex = 0; // 0 = الكل, 1 = الأقرب للمكافأة, 2 = المفضلة

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = appState.strings;
    final isArabic = strings.isArabic;
    final cafes = appState.cafes;

    // Filter logic
    List<Cafe> displayCafes = List.from(cafes);
    if (_selectedFilterIndex == 1) {
      // Sort by remaining orders ascending (closest to reward first)
      displayCafes.sort((a, b) {
        final remA = appState.getRemainingOrdersForReward(a.id);
        final remB = appState.getRemainingOrdersForReward(b.id);
        return remA.compareTo(remB);
      });
    } else if (_selectedFilterIndex == 2) {
      // Favorites only
      displayCafes = displayCafes.where((c) => appState.isFavorite(c.id)).toList();
    }

    // Total stats across all cafes
    int totalCups = 0;
    for (final cafe in cafes) {
      final count = appState.getOrdersCountForCafe(cafe.id);
      totalCups += count;
    }

    final filterPills = [
      isArabic ? 'جميع المقاهي' : 'All Cafés',
      isArabic ? 'الأقرب للمكافأة ⚡' : 'Closest to Reward ⚡',
      isArabic ? 'المفضلة ❤️' : 'Favorites ❤️',
    ];

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isArabic ? 'بطاقات الولاء والمكافآت' : 'Loyalty & Rewards',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: AppColors.deepRoast,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Overview Summary Card
            FadeSlideTransition(
              delay: const Duration(milliseconds: 50),
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
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
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
                              isArabic ? 'برنامج ولاء CupBack' : 'CupBack Rewards',
                              style: const TextStyle(
                                color: Color(0xFF221208),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isArabic ? 'اجمع الأكواب، واستمتع بالخصم' : 'Collect Cups, Enjoy Discounts',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isArabic
                                ? 'كل كافيه له بطاقة أختام وعروض خاصة به.'
                                : 'Each partner café has its own stamps & reward.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Quick stats pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.coffee_rounded, color: Color(0xFFECA062), size: 24),
                          const SizedBox(height: 4),
                          Text(
                            '$totalCups',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            isArabic ? 'أكواب مسجلة' : 'Total Cups',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2. Filter Pills
            FadeSlideTransition(
              delay: const Duration(milliseconds: 100),
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: filterPills.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilterIndex == index;
                    return PressableScale(
                      scaleFactor: 0.94,
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
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
                          filterPills[index],
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

            const SizedBox(height: 14),

            // 3. Cafe Loyalty Cards List (Per-Cafe Breakdown)
            if (displayCafes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.coffee_outlined, size: 48, color: AppColors.coffeeMuted),
                      const SizedBox(height: 10),
                      Text(
                        isArabic ? 'لا توجد كافيهات في هذا القسم' : 'No cafés found',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.deepRoast),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...List.generate(displayCafes.length, (index) {
                final cafe = displayCafes[index];
                final orderCount = appState.getOrdersCountForCafe(cafe.id);
                final requiredOrders = cafe.requiredOrdersForReward;
                final remaining = appState.getRemainingOrdersForReward(cafe.id);
                final progressCups = orderCount % requiredOrders;
                final isRewardUnlocked = remaining == 0 && orderCount > 0;

                return FadeSlideTransition(
                  delay: Duration(milliseconds: 140 + (index * 60)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isRewardUnlocked
                              ? AppColors.caramelAccent
                              : const Color(0xFFECE6DD),
                          width: isRewardUnlocked ? 1.8 : 1.0,
                        ),
                        boxShadow: AppDecorations.softCardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cafe Header: Logo, Name, Location & Quick Favorite
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  color: const Color(0xFFF7F4EE),
                                  child: cafe.image != null && cafe.image!.isNotEmpty
                                      ? Image.network(
                                          cafe.image!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.coffee_rounded,
                                            color: AppColors.deepRoast,
                                          ),
                                        )
                                      : const Icon(Icons.coffee_rounded, color: AppColors.deepRoast),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cafe.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.deepRoast,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${cafe.location} • ${cafe.distance}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.coffeeMuted,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Counter Pill (e.g. 4 / 6)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F4EE),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE8E0D5)),
                                ),
                                child: Text(
                                  '$progressCups / $requiredOrders ${isArabic ? 'أكواب' : 'cups'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.deepRoast,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Visual Stamps Row (Cups Progress)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF8F5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFEFE8DE)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(requiredOrders, (cupIdx) {
                                final isFilled = cupIdx < progressCups;
                                final isLastSlot = cupIdx == requiredOrders - 1;

                                return Column(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: isFilled
                                            ? AppColors.deepRoast
                                            : (isLastSlot
                                                ? const Color(0xFFFFF3E0)
                                                : Colors.white),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isFilled
                                              ? AppColors.deepRoast
                                              : (isLastSlot
                                                  ? AppColors.caramelAccent
                                                  : const Color(0xFFE2D7CB)),
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
                                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                                            : (isLastSlot
                                                ? const Icon(Icons.card_giftcard_rounded, color: AppColors.caramelAccent, size: 18)
                                                : const Icon(Icons.coffee_rounded, color: Color(0xFFC7B8A8), size: 18)),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${cupIdx + 1}',
                                      style: TextStyle(
                                        fontSize: 10,
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

                          // Status text: Exactly what user requested ("فاضلي كام كوب ع الخصم")
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isRewardUnlocked
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFDF6EE),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isRewardUnlocked
                                    ? AppColors.success.withValues(alpha: 0.4)
                                    : AppColors.caramelAccent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isRewardUnlocked
                                      ? Icons.celebration_rounded
                                      : Icons.local_fire_department_rounded,
                                  size: 18,
                                  color: isRewardUnlocked ? AppColors.success : AppColors.caramelAccent,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    isRewardUnlocked
                                        ? (isArabic
                                            ? 'مبروك! كملت البطاقة، مشروبك القادم مجاني بالكامل 🎁'
                                            : 'Congrats! Free drink unlocked!')
                                        : (isArabic
                                            ? 'فاضلك $remaining ${remaining == 1 ? 'كوب واحد' : (remaining == 2 ? 'كوبين' : 'أكواب')} فقط وتاخد الخصم / الكوب المجاني!'
                                            : 'Just $remaining more ${remaining == 1 ? 'cup' : 'cups'} to unlock your free reward!'),
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: isRewardUnlocked
                                          ? const Color(0xFF1B5E20)
                                          : AppColors.deepRoast,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Active Offer Badge & Order Button
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${isArabic ? 'عرض الكافيه:' : 'Offer:'} ${cafe.activeOffer}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.coffeeMuted,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              PressableScale(
                                scaleFactor: 0.92,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CafeDetailsScreen(cafe: cafe),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: AppColors.deepRoast,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isArabic ? 'اطلب الآن' : 'Order Now',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

            const SizedBox(height: 10),

            // 4. How CupBack Loyalty Works
            FadeSlideTransition(
              delay: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFECE6DD)),
                  boxShadow: AppDecorations.softCardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.coffee_rounded, color: AppColors.caramelAccent, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          isArabic ? 'كيف يعمل برنامج ولاء CupBack؟ ☕' : 'How CupBack Loyalty Works ☕',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13.5,
                            color: AppColors.deepRoast,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildLoyaltyRule(
                      number: '1',
                      text: isArabic
                          ? 'اطلب قهوتك من أي كافيه شريك، ويتم ختم الكوب تلقائياً في حسابك.'
                          : 'Order from any partner cafe, and your cup is stamped automatically.',
                    ),
                    _buildLoyaltyRule(
                      number: '2',
                      text: isArabic
                          ? 'لكل كافيه بطاقة ولاء مستقلة ومكافأة خاصة به.'
                          : 'Each cafe has an independent loyalty card and custom rewards.',
                    ),
                    _buildLoyaltyRule(
                      number: '3',
                      text: isArabic
                          ? 'عند اكتمال الـ 6 أكواب، استلم مشروبك القادم مجاناً وابدأ دورة جديدة.'
                          : 'Collect all 6 cups to claim your free reward and start a new cycle.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }

  Widget _buildLoyaltyRule({required String number, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.caramelAccent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.deepRoast,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
