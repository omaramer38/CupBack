import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/state/app_state.dart';
import '../core/models/order_model.dart';
import '../core/widgets/pressable_scale.dart';
import '../core/widgets/rating_modal.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = appState.strings;
    final isArabic = strings.isArabic;
    final order = appState.rawActiveOrder ?? widget.order;

    final orderCount = appState.getOrdersCountForCafe(order.cafeId);
    final remainingOrders = appState.getRemainingOrdersForReward(order.cafeId);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isArabic ? 'تتبع حالة الطلب' : 'Track Active Order',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.deepRoast),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.deepRoast),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: isArabic ? 'مساعدة' : 'Help',
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.deepRoast),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? 'تواصل مع كافيه ${order.cafeName}' : 'Contacting ${order.cafeName}'),
                  backgroundColor: AppColors.deepRoast,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Time Remaining & Live Status Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B110B), Color(0xFF382013)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: AppDecorations.elevatedCardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'طلب #${order.id}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.caramelAccent.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.caramelAccent.withValues(alpha: 0.6)),
                        ),
                        child: Text(
                          order.orderType,
                          style: const TextStyle(color: AppColors.caramelLight, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Icon(
                    order.status == OrderStatus.ready
                        ? Icons.check_circle_rounded
                        : Icons.access_time_filled_rounded,
                    color: AppColors.caramelLight,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    order.status == OrderStatus.ready
                        ? (isArabic ? 'طلبك جاهز للاستلام الآن! ☕' : 'Your order is ready for pickup! ☕')
                        : (order.status == OrderStatus.completed
                            ? (isArabic ? 'تم استلام الطلب بنجاح 🎉' : 'Order Completed 🎉')
                            : (isArabic
                                ? 'متبقي حوالي ${order.estimatedMinutesRemaining} دقائق'
                                : 'Approx. ${order.estimatedMinutesRemaining} mins remaining')),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.cafeName} • ${isArabic ? order.statusTextAr : order.statusTextEn}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Step-by-Step Progress Timeline
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEBE5DC), width: 1),
                boxShadow: AppDecorations.softCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'مراحل تجهيز الطلب' : 'Preparation Timeline',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepRoast),
                  ),
                  const SizedBox(height: 16),
                  _buildTimelineStep(
                    title: isArabic ? 'تم استلام وتأكيد الطلب' : 'Order Received & Confirmed',
                    time: isArabic ? 'منذ دقائق' : 'Minutes ago',
                    isPassed: true,
                    isCurrent: order.status == OrderStatus.received,
                  ),
                  _buildTimelineConnector(isPassed: order.status.index >= OrderStatus.preparing.index),
                  _buildTimelineStep(
                    title: isArabic ? 'قيد التحضير في الكافيه' : 'Preparing at the Café',
                    time: order.status == OrderStatus.preparing
                        ? (isArabic ? 'متبقي ${order.estimatedMinutesRemaining} د' : '${order.estimatedMinutesRemaining}m left')
                        : '',
                    isPassed: order.status.index >= OrderStatus.preparing.index,
                    isCurrent: order.status == OrderStatus.preparing,
                  ),
                  _buildTimelineConnector(isPassed: order.status.index >= OrderStatus.ready.index),
                  _buildTimelineStep(
                    title: isArabic ? 'جاهز للاستلام عند الكاشير' : 'Ready for Pickup at Counter',
                    time: order.status == OrderStatus.ready ? (isArabic ? 'الآن' : 'Now') : '',
                    isPassed: order.status.index >= OrderStatus.ready.index,
                    isCurrent: order.status == OrderStatus.ready,
                  ),
                  _buildTimelineConnector(isPassed: order.status == OrderStatus.completed),
                  _buildTimelineStep(
                    title: isArabic ? 'تم الاستلام وإضافة الأكواب' : 'Completed & Stamped',
                    time: '',
                    isPassed: order.status == OrderStatus.completed,
                    isCurrent: order.status == OrderStatus.completed,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Cafe Loyalty & Stamp Milestone Card (المطلوب نصاً من المستخدم)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F1E9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.caramelAccent.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.caramelAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.loyalty_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'رميات الولاء في ${order.cafeName}' : 'Loyalty Stamps at ${order.cafeName}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5, color: AppColors.deepRoast),
                            ),
                            Text(
                              isArabic
                                  ? 'إجمالي طلباتك: $orderCount طلبات مسجلة'
                                  : 'Total orders: $orderCount recorded',
                              style: const TextStyle(fontSize: 11, color: AppColors.mediumRoast),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.card_giftcard_rounded, color: AppColors.caramelDark, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isArabic
                                ? '🎉 باقي لك $remainingOrders طلبات وتكسب المشروب المجاني القادم!'
                                : '🎉 Just $remainingOrders more orders to claim your free reward!',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.caramelDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Order Items & Cash Due Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFEBE5DC), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'تفاصيل الفاتورة والدفع' : 'Payment & Items',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepRoast),
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.quantity}x ${item.product.name}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.deepRoast),
                          ),
                          Text(
                            '${item.totalPrice.toStringAsFixed(0)} ج.م',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 20, color: Color(0xFFF1EAE0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic ? 'المبلغ المطلوب دفعه كاش' : 'Cash Amount Due',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.deepRoast),
                      ),
                      Text(
                        '${order.total.toStringAsFixed(0)} ج.م',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.caramelDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Post-Delivery Review & Rating Prompt
            if (order.status == OrderStatus.completed) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF9F2), Color(0xFFFDF2E3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.caramelAccent.withValues(alpha: 0.4)),
                  boxShadow: AppDecorations.softCardShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.caramelAccent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.rate_review_rounded,
                            color: AppColors.caramelAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.hasBeenRated
                                    ? (isArabic ? 'تم تقييم هذا الطلب بنجاح! 🌟' : 'Order Rated! 🌟')
                                    : (isArabic ? 'كيف كانت قهوتك وتجربتك اليوم؟' : 'How was your coffee & experience?'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.deepRoast,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                order.hasBeenRated
                                    ? (isArabic ? 'شكراً لرأيك، يساعدنا على تقديم أفضل جودة دائماً.' : 'Thank you for your valuable feedback.')
                                    : (isArabic ? 'شاركنا تقييمك لـ ${order.cafeName} في ثوانٍ معدودة' : 'Rate ${order.cafeName} in just a few seconds'),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.coffeeMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (!order.hasBeenRated)
                      PressableScale(
                        scaleFactor: 0.95,
                        onTap: () {
                          RatingModal.show(
                            context,
                            order,
                            onSubmitted: () => setState(() {}),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.deepRoast, Color(0xFF3B1E12)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.deepRoast.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                              const SizedBox(width: 6),
                              Text(
                                isArabic ? 'قيّم التجربة والكافيه الآن ⭐' : 'Rate Your Experience Now ⭐',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5DDD3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              isArabic ? 'تم حفظ التقييم وحساب النقاط والكوبون' : 'Review recorded successfully',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepRoast,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Simulation button for testing (Simulate Next Status)
            if (order.status != OrderStatus.completed)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    appState.advanceActiveOrderStatus();
                    if (appState.activeOrder?.status == OrderStatus.completed && !order.hasBeenRated) {
                      Future.delayed(const Duration(milliseconds: 350), () {
                        if (!context.mounted) return;
                        RatingModal.show(context, order, onSubmitted: () => setState(() {}));
                      });
                    }
                  },
                  icon: const Icon(Icons.fast_forward_rounded, color: AppColors.deepRoast, size: 18),
                  label: Text(
                    isArabic ? 'محاكاة: تحديث مرحلة التحضير تجريبياً' : 'Simulate: Advance Order Status',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.deepRoast),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    side: const BorderSide(color: Color(0xFFD6C8BB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            const SizedBox(height: 10),

            // Return to Home Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepRoast,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  isArabic ? 'العودة للرئيسية' : 'Return to Home',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String time,
    required bool isPassed,
    required bool isCurrent,
  }) {
    Color nodeColor = const Color(0xFFE5DDD3);
    if (isPassed) nodeColor = AppColors.deepRoast;
    if (isCurrent) nodeColor = AppColors.caramelAccent;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: nodeColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? AppColors.caramelLight : Colors.transparent,
              width: 2,
            ),
          ),
          child: isPassed
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isCurrent || isPassed ? FontWeight.bold : FontWeight.w500,
              color: isPassed ? AppColors.deepRoast : AppColors.coffeeMuted,
            ),
          ),
        ),
        if (time.isNotEmpty)
          Text(
            time,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.caramelDark),
          ),
      ],
    );
  }

  Widget _buildTimelineConnector({required bool isPassed}) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 11),
      width: 2,
      height: 20,
      color: isPassed ? AppColors.deepRoast : const Color(0xFFE5DDD3),
    );
  }
}
