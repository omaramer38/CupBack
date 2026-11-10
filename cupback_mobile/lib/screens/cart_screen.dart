import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/state/app_state.dart';
import 'order_tracking_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _orderType = 'استلام من الكافيه (Pickup)';
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleConfirmOrder(AppState appState) {
    if (appState.cart.isEmpty) return;

    final order = appState.placeOrder(
      orderType: _orderType,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderTrackingScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = appState.strings;
    final isArabic = strings.isArabic;
    final cart = appState.cart;

    if (cart.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFBF9F5),
        appBar: AppBar(
          title: Text(isArabic ? 'سلة الطلبات' : 'Cart'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 70, color: AppColors.coffeeMuted.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(
                isArabic ? 'سلتك فارغة حالياً' : 'Your cart is empty',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
              ),
              const SizedBox(height: 6),
              Text(
                isArabic ? 'تصفح قائمة المقاهي واختر مشروباتك المفضلة' : 'Explore cafés and add your favorite drinks',
                style: const TextStyle(fontSize: 12, color: AppColors.coffeeMuted),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepRoast),
                child: Text(isArabic ? 'تصفح المقاهي' : 'Explore Cafés'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? 'سلة الطلبات' : 'Cart',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
            ),
            Text(
              '${appState.cartCafeName ?? ''}',
              style: const TextStyle(fontSize: 12, color: AppColors.coffeeMuted, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isArabic ? 'مسح السلة' : 'Clear Cart',
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () {
              appState.clearCart();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Items List
            Text(
              isArabic ? 'المشروبات والطلبات المختارة' : 'Selected Items',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.deepRoast),
            ),
            const SizedBox(height: 12),
            ...cart.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEBE5DC), width: 1),
                  boxShadow: AppDecorations.softCardShadow,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 52,
                        height: 52,
                        color: const Color(0xFFF7F3ED),
                        child: item.product.image != null && item.product.image!.isNotEmpty
                            ? Image.network(
                                item.product.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.coffee_rounded, color: AppColors.deepRoast, size: 22),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.coffee_rounded, color: AppColors.deepRoast, size: 22),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
                          ),
                          if (item.selectedSize != null || item.selectedAddOns.isNotEmpty || item.selectedSweetness != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2, bottom: 2),
                              child: Text(
                                [
                                  if (item.selectedSize != null) item.selectedSize!,
                                  if (item.selectedSweetness != null) item.selectedSweetness!,
                                  ...item.selectedAddOns,
                                ].join(' • '),
                                style: const TextStyle(fontSize: 11, color: Color(0xFFC87C43), fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (item.notes != null && item.notes!.isNotEmpty)
                            Text(
                              'ملاحظة: ${item.notes}',
                              style: TextStyle(fontSize: 10.5, color: AppColors.deepRoast.withValues(alpha: 0.6)),
                            ),
                          Text(
                            '${item.unitPrice.toStringAsFixed(0)} ج.م',
                            style: const TextStyle(fontSize: 12, color: AppColors.coffeeMuted, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    // Quantity Stepper
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1EBE2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => appState.updateCartQuantity(item.product.id, -1),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.remove, size: 14, color: AppColors.deepRoast),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.deepRoast),
                            ),
                          ),
                          InkWell(
                            onTap: () => appState.updateCartQuantity(item.product.id, 1),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.add, size: 14, color: AppColors.deepRoast),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),

            // 2. Order Type (Pickup or Dine-in)
            Text(
              isArabic ? 'طريقة الاستلام' : 'Fulfillment Type',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepRoast),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildOrderTypeChoice(
                    title: isArabic ? 'استلام من الكافيه' : 'Pickup',
                    subtitle: isArabic ? 'استلم بنفسك بدون انتظار' : 'Pickup at branch',
                    icon: Icons.shopping_bag_outlined,
                    value: 'استلام من الكافيه (Pickup)',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildOrderTypeChoice(
                    title: isArabic ? 'تناول في الكافيه' : 'Dine-In',
                    subtitle: isArabic ? 'جلسات داخلية' : 'Table service',
                    icon: Icons.chair_alt_outlined,
                    value: 'تناول في الكافيه (Dine-in)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 3. Payment Method (Cash on Pickup)
            Text(
              isArabic ? 'طريقة الدفع' : 'Payment Method',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.deepRoast),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFEBE5DC), width: 1),
                boxShadow: AppDecorations.softCardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.payments_rounded, color: AppColors.success, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'كاش عند الاستلام' : 'Cash on Pickup',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.deepRoast),
                            ),
                            Text(
                              isArabic ? 'ادفع نقداً عند استلام طلبك من الفرع' : 'Pay in cash when picking up',
                              style: const TextStyle(fontSize: 11, color: AppColors.coffeeMuted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle_rounded, color: AppColors.caramelAccent, size: 22),
                    ],
                  ),
                  const Divider(height: 20, color: Color(0xFFF1EAE0)),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F3ED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: AppColors.mediumRoast),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isArabic
                                ? 'الدفع الإلكتروني (فيزا / محافظ إلكترونية) قيد التعاقد والربط حالياً وسيتوفر في التحديث القادم.'
                                : 'Online payments (Cards/Wallets) are currently being integrated and will be available soon.',
                            style: const TextStyle(fontSize: 11, color: AppColors.mediumRoast, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Notes to Barista
            Text(
              isArabic ? 'ملاحظات إضافية للكافيه (اختياري)' : 'Notes for Barista (Optional)',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepRoast),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: isArabic ? 'مثال: سكر خفيف، حليب شوفان، ثلج زيادة...' : 'e.g. Extra ice, less sugar...',
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9E8B7E)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFEBE5DC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFEBE5DC)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 5. Price Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFEBE5DC), width: 1),
              ),
              child: Column(
                children: [
                  _buildPriceRow(isArabic ? 'المجموع الفرعي' : 'Subtotal', '${appState.cartSubtotal.toStringAsFixed(0)} ج.م'),
                  const SizedBox(height: 8),
                  _buildPriceRow(isArabic ? 'رسوم الخدمة' : 'Service Fee', isArabic ? 'مجاناً 🎁' : 'Free 🎁'),
                  const Divider(height: 20, color: Color(0xFFF1EAE0)),
                  _buildPriceRow(
                    isArabic ? 'الإجمالي المطلوب كاش' : 'Total Cash Due',
                    '${appState.cartSubtotal.toStringAsFixed(0)} ج.م',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleConfirmOrder(appState),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepRoast,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isArabic ? 'تأكيد وإرسال الطلب (كاش)' : 'Confirm Order (Cash)',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeChoice({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = _orderType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _orderType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1EBE2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.deepRoast : const Color(0xFFEBE5DC),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? AppColors.deepRoast : AppColors.coffeeMuted, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.deepRoast : AppColors.mediumRoast,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: AppColors.coffeeMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14.5 : 12.5,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            color: isTotal ? AppColors.deepRoast : AppColors.coffeeMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
            color: isTotal ? AppColors.caramelDark : AppColors.deepRoast,
          ),
        ),
      ],
    );
  }
}
