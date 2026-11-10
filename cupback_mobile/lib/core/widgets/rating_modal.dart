import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import '../models/order_model.dart';
import 'pressable_scale.dart';

class RatingModal extends StatefulWidget {
  final OrderModel? order;
  final String? cafeId;
  final String? cafeName;
  final VoidCallback? onReviewSubmitted;

  const RatingModal({
    super.key,
    this.order,
    this.cafeId,
    this.cafeName,
    this.onReviewSubmitted,
  });

  static Future<void> show(BuildContext context, OrderModel order, {VoidCallback? onSubmitted}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RatingModal(
        order: order,
        onReviewSubmitted: onSubmitted,
      ),
    );
  }

  static Future<void> showForCafe(
    BuildContext context, {
    required String cafeId,
    required String cafeName,
    VoidCallback? onSubmitted,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RatingModal(
        cafeId: cafeId,
        cafeName: cafeName,
        onReviewSubmitted: onSubmitted,
      ),
    );
  }

  @override
  State<RatingModal> createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  double _selectedRating = 5.0;
  final Set<String> _selectedTags = {'☕ قهوة مظبوطة', '⚡ سرعة استلام'};
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _quickTagsAr = [
    '☕ قهوة مظبوطة',
    '⚡ سرعة استلام',
    '👨‍🍳 باريستا محترف',
    '📦 تغليف ممتاز',
    '🥐 طازج ولذيذ',
    '🤍 تعامل راقي',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _getRatingFeedbackText(double rating, bool isArabic) {
    if (rating >= 5.0) return isArabic ? 'تجربة استثنائية وممتازة! 🌟' : 'Exceptional experience! 🌟';
    if (rating >= 4.0) return isArabic ? 'تجربة رائعة جداً! 😊' : 'Very good experience! 😊';
    if (rating >= 3.0) return isArabic ? 'جيد، ولديهم مساحة للتحسين 🙂' : 'Good, some room to improve 🙂';
    if (rating >= 2.0) return isArabic ? 'أقل من المتوقع 😐' : 'Below expectations 😐';
    return isArabic ? 'تجربة غير مرضية 😞' : 'Unsatisfactory 😞';
  }

  void _submitReview(AppState appState) {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final commentText = _commentController.text.trim().isNotEmpty
        ? _commentController.text.trim()
        : 'تجربة ممتازة وقهوة على أعلى مستوى!';

    final targetCafeId = widget.order?.cafeId ?? widget.cafeId ?? '';
    final targetCafeName = widget.order?.cafeName ?? widget.cafeName ?? 'الكافيه';
    final targetOrderId = widget.order?.id ?? 'direct_${DateTime.now().millisecond}';

    appState.addCafeReview(
      cafeId: targetCafeId,
      orderId: targetOrderId,
      rating: _selectedRating,
      comment: commentText,
      tags: _selectedTags.toList(),
    );

    if (widget.order != null) {
      widget.order!.hasBeenRated = true;
    }

    Navigator.pop(context);

    if (widget.onReviewSubmitted != null) {
      widget.onReviewSubmitted!();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'شكراً لمشاركتك! تم إضافة تقييمك لكافيه $targetCafeName بنجاح ⭐',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.deepRoast,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isArabic = appState.strings.isArabic;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5DDD3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Cafe Logo & Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6EE),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF0E4D5)),
                  ),
                  child: const Icon(
                    Icons.coffee_rounded,
                    color: AppColors.caramelAccent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'كيف كانت تجربتك؟ ☕' : 'How was your order? ☕',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.deepRoast,
                        ),
                      ),
                      Text(
                        '${widget.order?.cafeName ?? widget.cafeName ?? 'الكافيه'}${widget.order != null ? ' • طلب #${widget.order!.id}' : ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.coffeeMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 5 Animated Interactive Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starScore = index + 1.0;
                final isSelected = starScore <= _selectedRating;

                return PressableScale(
                  scaleFactor: 0.82,
                  onTap: () {
                    setState(() {
                      _selectedRating = starScore;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 38,
                      color: isSelected ? const Color(0xFFF59E0B) : const Color(0xFFD6CBC0),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 8),

            // Rating description
            Text(
              _getRatingFeedbackText(_selectedRating, isArabic),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.caramelAccent,
              ),
            ),

            const SizedBox(height: 18),

            // Quick Tags Selector
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                isArabic ? 'ما أكثر ما نال إعجابك؟' : 'What did you like most?',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepRoast,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickTagsAr.map((tag) {
                final isChecked = _selectedTags.contains(tag);
                return PressableScale(
                  scaleFactor: 0.94,
                  onTap: () {
                    setState(() {
                      if (isChecked) {
                        _selectedTags.remove(tag);
                      } else {
                        _selectedTags.add(tag);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isChecked ? AppColors.deepRoast : const Color(0xFFFAF7F2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isChecked ? AppColors.deepRoast : const Color(0xFFE8E0D5),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isChecked ? FontWeight.w800 : FontWeight.w600,
                        color: isChecked ? Colors.white : AppColors.deepRoast,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Comment text field
            TextField(
              controller: _commentController,
              maxLines: 2,
              style: const TextStyle(fontSize: 13, color: AppColors.deepRoast),
              decoration: InputDecoration(
                hintText: isArabic
                    ? 'اكتب تعليقك للكافيه (مثال: القهوة ممتازة وسريعة، شكراً للباريستا)...'
                    : 'Write your comments for the café...',
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9E8B7E)),
                filled: true,
                fillColor: const Color(0xFFFAF8F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFECE6DD)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFECE6DD)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.caramelAccent, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: PressableScale(
                scaleFactor: 0.96,
                onTap: () => _submitReview(appState),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.deepRoast,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepRoast.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isArabic ? 'إرسال التقييم ⭐' : 'Submit Review ⭐',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
