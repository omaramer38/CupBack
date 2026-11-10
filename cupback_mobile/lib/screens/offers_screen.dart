import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'العروض',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.espressoBrown,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Hero Offer Card from Brand Board
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.vanillaLatte.withOpacity(0.6)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.espressoBrown.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coffee Image Container with Badge
                  Stack(
                    children: [
                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=600&auto=format&fit=crop&q=80',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.espressoBrown,
                                  child: const Center(
                                    child: Icon(Icons.coffee_rounded, size: 70, color: Colors.white24),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.6),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        top: 14,
                        end: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.caramelAccent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'عرض خاص',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'خصم 20% على المشروبات الباردة',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.espressoBrown,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'في مقهى الزيتون',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.caramelAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.espressoBrown),
                            const SizedBox(width: 6),
                            Text(
                              'ساري حتى 31 يناير',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.espressoBrown.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم تطبيق العرض على طلبك القادم! 🎉'),
                                  backgroundColor: AppColors.espressoBrown,
                                ),
                              );
                            },
                            child: const Text('استخدم العرض'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'عروض أخرى متاحة',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.espressoBrown,
              ),
            ),
            const SizedBox(height: 12),

            // Additional offer card 1
            _buildSmallOfferCard(
              title: 'كوب مجاني عند شراء مشروبين',
              cafe: 'كافيه أروما (Aroma)',
              expiry: 'ساري حتى يوم الخميس',
              discountTag: '1 + 1 مجانًا',
              imageUrl: 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=300&auto=format&fit=crop&q=80',
            ),
            const SizedBox(height: 12),

            // Additional offer card 2
            _buildSmallOfferCard(
              title: 'خصم 15% للعملاء الجدد',
              cafe: 'مقهى البلدة',
              expiry: 'ساري طوال هذا الشهر',
              discountTag: 'ترحيب 15%',
              imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=300&auto=format&fit=crop&q=80',
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallOfferCard({
    required String title,
    required String cafe,
    required String expiry,
    required String discountTag,
    String? imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.vanillaLatte.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 56,
              height: 56,
              color: AppColors.vanillaLatte.withValues(alpha: 0.3),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.local_offer_rounded, color: AppColors.caramelAccent, size: 24),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.local_offer_rounded, color: AppColors.caramelAccent, size: 24),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.espressoBrown,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.caramelAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        discountTag,
                        style: const TextStyle(
                          color: AppColors.caramelAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  cafe,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.espressoBrown.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  expiry,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.espressoBrown.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
