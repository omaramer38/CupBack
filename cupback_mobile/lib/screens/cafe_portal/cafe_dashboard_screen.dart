import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/state/app_state.dart';
import '../../core/models/order_model.dart';
import '../../core/models/product.dart';
import '../../core/widgets/fade_slide_transition.dart';
import '../../core/widgets/pressable_scale.dart';

class CafeDashboardScreen extends StatefulWidget {
  const CafeDashboardScreen({super.key});

  @override
  State<CafeDashboardScreen> createState() => _CafeDashboardScreenState();
}

class _CafeDashboardScreenState extends State<CafeDashboardScreen> {
  int _selectedTab = 0; // 0: Live Orders KDS, 1: Stock & Menu Management
  OrderStatus? _selectedOrderStatusFilter; // null means 'All'
  String _orderSearchQuery = '';
  String _selectedMenuCategory = 'الكل';
  String _menuSearchQuery = '';
  bool _onlyShowOutOfStock = false; // Barista 86 Quick Filter

  final TextEditingController _orderSearchController = TextEditingController();
  final TextEditingController _menuSearchController = TextEditingController();

  @override
  void dispose() {
    _orderSearchController.dispose();
    _menuSearchController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Dialog: Scan Customer QR Code / Stamp Loyalty Cups (+1)
  // ---------------------------------------------------------------------------
  void _showScanQrDialog(AppState appState) {
    final strings = appState.strings;
    final isArabic = strings.isArabic;
    final phoneController = TextEditingController();
    int cupsToStamp = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5DDD3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.caramelAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.caramelAccent, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'مسح QR كود الزبون' : 'Scan Customer QR',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.deepRoast,
                              ),
                            ),
                            Text(
                              isArabic ? 'إضافة كوب ولاء فوري في كاونتر الكافيه' : 'Instant loyalty cup stamp at counter',
                              style: const TextStyle(fontSize: 12, color: AppColors.coffeeMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Simulated Interactive Camera Viewfinder
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.deepRoast,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppDecorations.softCardShadow,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.caramelAccent, width: 2.5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Center(
                            child: Icon(Icons.qr_code_2_rounded, size: 68, color: Colors.white70),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isArabic ? 'وجّه كاميرا الكاونتر نحو شاشة هاتف العميل' : 'Align camera with customer QR code',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  Text(
                    isArabic ? 'أو أدخل رقم هاتف العميل يدوياً:' : 'Or enter phone number manually:',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.deepRoast),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: isArabic ? 'مثال: 01012345678' : 'e.g. 01012345678',
                      prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.coffeeMuted),
                      filled: true,
                      fillColor: const Color(0xFFFBF8F5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFECE6DD)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFECE6DD)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        isArabic ? 'عدد الأكواب المراد ختمها:' : 'Cups to stamp:',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.deepRoast),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: cupsToStamp > 1
                            ? () => setModalState(() => cupsToStamp--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.deepRoast),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F0EA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$cupsToStamp ${isArabic ? 'كوب' : 'cup'}',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.deepRoast),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setModalState(() => cupsToStamp++),
                        icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.caramelAccent),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final phone = phoneController.text.trim().isNotEmpty
                            ? phoneController.text.trim()
                            : '01012345678';
                        final cafeId = 'cafe_1';

                        appState.recordCustomerStamp(cafeId: cafeId, phone: phone, cups: cupsToStamp);
                        Navigator.pop(ctx);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    isArabic
                                        ? 'تم ختم $cupsToStamp كوب بنجاح لحساب ($phone) 🎉'
                                        : 'Stamped $cupsToStamp cup(s) for ($phone) successfully 🎉',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.deepRoast,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepRoast,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_cafe_rounded, color: AppColors.caramelAccent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            isArabic ? 'تأكيد إضافة الكوب والختم' : 'Confirm & Stamp Cup',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Modal: Quick 86 / Out of Stock Fast Sheet for Barista
  // ---------------------------------------------------------------------------
  void _showQuick86Modal(BuildContext context, AppState appState, List<Product> products) {
    final isArabic = appState.strings.isArabic;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) {
          return Container(
            height: MediaQuery.of(ctx).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5DDD3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.remove_shopping_cart_rounded, color: AppColors.error, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'لوحة النواقص السريعة (86 Quick Out of Stock)' : '86 Quick Out of Stock',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15.5, color: AppColors.deepRoast),
                          ),
                          Text(
                            isArabic ? 'عطّل أي صنف نفذت مكوناته بلمسة واحدة بدون انتظار المدير' : 'Instantly disable items out of ingredients',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.coffeeMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFECE6DD)),
                const SizedBox(height: 8),

                Expanded(
                  child: ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3ECE4)),
                    itemBuilder: (ctx, index) {
                      final item = products[index];
                      final isAvailable = item.isAvailable;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.image ?? '',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 40,
                                  height: 40,
                                  color: const Color(0xFFF0EBE4),
                                  child: const Icon(Icons.coffee, color: AppColors.deepRoast, size: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.5,
                                      color: isAvailable ? AppColors.deepRoast : const Color(0xFF8D6E63),
                                      decoration: isAvailable ? null : TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Text(
                                    '${item.price.toStringAsFixed(0)} ج.م • ${item.category}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.coffeeMuted),
                                  ),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: isAvailable,
                              activeTrackColor: const Color(0xFF2E7D32),
                              activeThumbColor: Colors.white,
                              inactiveTrackColor: const Color(0xFFEF9A9A),
                              inactiveThumbColor: AppColors.error,
                              onChanged: (val) {
                                appState.toggleProductAvailability(item.id);
                                setModalState(() {});
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepRoast,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      isArabic ? 'تم وتطبيق التحديثات' : 'Done & Apply',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Modal: Quick Edit Product Price & Stock
  // ---------------------------------------------------------------------------
  // Reusable Senior UI/UX Image Picker Section with Instant Live Preview & Presets
  // ---------------------------------------------------------------------------
  Widget _buildImagePickerSection({
    required bool isArabic,
    required String selectedImageUrl,
    required TextEditingController customUrlController,
    required void Function(String newUrl) onImageSelected,
  }) {
    final presetImages = [
      {'name': 'لاتيه مثلج', 'url': 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=500&auto=format&fit=crop&q=80'},
      {'name': 'فلات وايت', 'url': 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?w=500&auto=format&fit=crop&q=80'},
      {'name': 'كولد برو', 'url': 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=500&auto=format&fit=crop&q=80'},
      {'name': 'V60 مقطرة', 'url': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500&auto=format&fit=crop&q=80'},
      {'name': 'إسبريسو', 'url': 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=500&auto=format&fit=crop&q=80'},
      {'name': 'موكا مثلجة', 'url': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=500&auto=format&fit=crop&q=80'},
      {'name': 'كرواسون', 'url': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=500&auto=format&fit=crop&q=80'},
      {'name': 'كوكيز', 'url': 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=500&auto=format&fit=crop&q=80'},
      {'name': 'تشيز كيك', 'url': 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=500&auto=format&fit=crop&q=80'},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECE6DD), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  selectedImageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    color: const Color(0xFFEBE4DC),
                    child: const Icon(Icons.photo_camera_rounded, color: AppColors.deepRoast, size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'صورة الصنف' : 'Product Image',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.deepRoast),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isArabic ? 'اختر صورة من النماذج السريعة أو أدخل رابطاً مخصصاً' : 'Tap a quick preset below or paste image URL',
                      style: const TextStyle(fontSize: 11, color: AppColors.coffeeMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isArabic ? 'نماذج صور جاهزة (اضغط للاختيار):' : 'Quick Presets (Tap to select):',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: presetImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, idx) {
                final item = presetImages[idx];
                final isSelected = selectedImageUrl == item['url'];
                return GestureDetector(
                  onTap: () {
                    onImageSelected(item['url']!);
                    customUrlController.text = item['url']!;
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.caramelAccent : const Color(0xFFDED8D0),
                            width: isSelected ? 2.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: AppColors.caramelAccent.withValues(alpha: 0.3), blurRadius: 6)]
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                item['url']!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 20),
                              ),
                              if (isSelected)
                                Container(
                                  color: Colors.black38,
                                  child: const Center(
                                    child: Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.caramelAccent : AppColors.deepRoast,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: customUrlController,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              isDense: true,
              labelText: isArabic ? 'أو رابط صورة مخصص (URL):' : 'Or Custom Image URL:',
              labelStyle: const TextStyle(fontSize: 11, color: AppColors.coffeeMuted),
              hintText: 'https://...',
              hintStyle: const TextStyle(fontSize: 11, color: Color(0xFFBDBDBD)),
              prefixIcon: const Icon(Icons.link_rounded, size: 18, color: AppColors.caramelAccent),
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.caramelAccent),
                onPressed: () {
                  if (customUrlController.text.trim().isNotEmpty) {
                    onImageSelected(customUrlController.text.trim());
                  }
                },
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFECE6DD))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFECE6DD))),
            ),
            onChanged: (val) {
              if (val.trim().isNotEmpty) {
                onImageSelected(val.trim());
              }
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Modal: Quick Edit Product (Name, Price, Image, Description)
  // ---------------------------------------------------------------------------
  void _showQuickEditProductModal(BuildContext context, AppState appState, Product product) {
    final isArabic = appState.strings.isArabic;
    final priceController = TextEditingController(text: product.price.toStringAsFixed(0));
    final nameController = TextEditingController(text: product.name);
    final descController = TextEditingController(text: product.description);
    String selectedImageUrl = product.image ?? 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=500&auto=format&fit=crop&q=80';
    final customUrlController = TextEditingController(text: product.image ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.88,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 16),
                    Text(
                      isArabic ? 'تعديل الصنف في المنيو' : 'Edit Menu Item',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.deepRoast),
                    ),
                    const SizedBox(height: 14),

                    // Image Picker Section
                    _buildImagePickerSection(
                      isArabic: isArabic,
                      selectedImageUrl: selectedImageUrl,
                      customUrlController: customUrlController,
                      onImageSelected: (newUrl) {
                        setModalState(() => selectedImageUrl = newUrl);
                      },
                    ),

                    const SizedBox(height: 16),
                    Text(
                      isArabic ? 'اسم الصنف:' : 'Item Name:',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFFBF8F5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFECE6DD))),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      isArabic ? 'السعر (ج.م):' : 'Price (EGP):',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFFBF8F5),
                        prefixIcon: const Icon(Icons.payments_outlined, color: AppColors.caramelAccent),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFECE6DD))),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      isArabic ? 'وصف الصنف:' : 'Description:',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: descController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFFBF8F5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFECE6DD))),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final parsedPrice = double.tryParse(priceController.text) ?? product.price;
                          final updated = product.copyWith(
                            name: nameController.text.trim().isNotEmpty ? nameController.text.trim() : product.name,
                            price: parsedPrice,
                            image: selectedImageUrl,
                            description: descController.text.trim().isNotEmpty ? descController.text.trim() : product.description,
                          );
                          appState.updateProduct(updated);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isArabic ? 'تم تحديث بيانات الصنف بنجاح ✅' : 'Item updated successfully ✅'),
                              backgroundColor: AppColors.deepRoast,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepRoast,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          isArabic ? 'حفظ التعديلات' : 'Save Changes',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }

  // ---------------------------------------------------------------------------
  // Modal: Add New Product to Menu (With Image Picker & Presets)
  // ---------------------------------------------------------------------------
  void _showAddProductModal(BuildContext context, AppState appState, String cafeId) {
    final isArabic = appState.strings.isArabic;
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    String category = 'مشروبات باردة';
    String selectedImageUrl = 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=500&auto=format&fit=crop&q=80';
    final customUrlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.88,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 16),
                    Text(
                      isArabic ? 'إضافة صنف جديد لقائمة الكافيه' : 'Add New Menu Item',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.deepRoast),
                    ),
                    const SizedBox(height: 14),

                    // Image Picker Section
                    _buildImagePickerSection(
                      isArabic: isArabic,
                      selectedImageUrl: selectedImageUrl,
                      customUrlController: customUrlController,
                      onImageSelected: (newUrl) {
                        setModalState(() => selectedImageUrl = newUrl);
                      },
                    ),

                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'اسم الصنف (مثلاً: أيس موكا)' : 'Item Name',
                        filled: true,
                        fillColor: const Color(0xFFFBF8F5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'السعر (ج.م)' : 'Price (EGP)',
                        filled: true,
                        fillColor: const Color(0xFFFBF8F5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      items: [
                        'مشروبات باردة',
                        'قهوة مختصة',
                        'إسبريسو وحليب',
                        'مخبوزات وحلويات',
                      ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => category = val);
                      },
                      decoration: InputDecoration(
                        labelText: isArabic ? 'القسم' : 'Category',
                        filled: true,
                        fillColor: const Color(0xFFFBF8F5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: isArabic ? 'وصف مختصر للمكونات' : 'Short Description',
                        filled: true,
                        fillColor: const Color(0xFFFBF8F5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.trim().isEmpty || priceController.text.trim().isEmpty) return;
                          final newProduct = Product(
                            id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                            cafeId: cafeId,
                            name: nameController.text.trim(),
                            nameEn: nameController.text.trim(),
                            description: descController.text.trim().isNotEmpty
                               ? descController.text.trim()
                               : 'مشروب محضر من أجود أنواع البن والمكونات الطازجة.',
                            price: double.tryParse(priceController.text) ?? 60.0,
                            category: category,
                            image: selectedImageUrl,
                            isAvailable: true,
                          );
                          appState.addProduct(cafeId, newProduct);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isArabic ? 'تمت إضافة الصنف بنجاح للفرع ✅' : 'Item added successfully ✅'),
                              backgroundColor: AppColors.deepRoast,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepRoast,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          isArabic ? 'إضافة الصنف للمنيو' : 'Add to Menu',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = appState.strings;
    final isArabic = strings.isArabic;
    final session = appState.session;

    // Clean cafe name (Arabic only, avoid English parentheses collision)
    final rawCafeName = session?.businessName ?? 'مقهى الزيتون';
    final cleanCafeName = rawCafeName.contains('(')
        ? rawCafeName.split('(').first.trim()
        : rawCafeName;

    final cafeId = 'cafe_1';
    final allOrders = appState.getCafeOrders(cafeId);

    // Filter live orders
    final filteredOrders = allOrders.where((order) {
      if (_selectedOrderStatusFilter != null && order.status != _selectedOrderStatusFilter) {
        return false;
      }
      if (_orderSearchQuery.isNotEmpty) {
        final q = _orderSearchQuery.toLowerCase();
        final matchNum = order.id.toLowerCase().contains(q);
        final matchCust = order.customerName.toLowerCase().contains(q);
        final matchPhone = order.customerPhone.toLowerCase().contains(q);
        if (!matchNum && !matchCust && !matchPhone) return false;
      }
      return true;
    }).toList();

    // Menu items
    final cafe = appState.cafes.firstWhere((c) => c.id == cafeId, orElse: () => appState.cafes.first);
    final menuItems = cafe.menu.where((p) {
      if (_onlyShowOutOfStock && p.isAvailable) {
        return false;
      }
      if (_selectedMenuCategory != 'الكل' && p.category != _selectedMenuCategory) {
        return false;
      }
      if (_menuSearchQuery.isNotEmpty) {
        final q = _menuSearchQuery.toLowerCase();
        final matchName = p.name.toLowerCase().contains(q) || p.nameEn.toLowerCase().contains(q);
        if (!matchName) return false;
      }
      return true;
    }).toList();

    // Shift summary metrics
    final completedOrders = allOrders.where((o) => o.status == OrderStatus.completed).toList();
    final todayCash = completedOrders.fold<double>(0.0, (sum, o) => sum + o.total);
    final todayStamps = appState.getCustomersForCafe(cafeId).fold<int>(0, (sum, c) => sum + c.stampsCount);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F4EF),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. Top Barista Header & Shift Status (Floating Card with Senior UI/UX Margins & Rounded Corners)
              _buildShiftHeader(
                context: context,
                appState: appState,
                isArabic: isArabic,
                cafeName: cleanCafeName,
                todayCash: todayCash,
                totalOrdersCount: allOrders.length,
                stampsGiven: todayStamps,
              ),

              // 2. Fast 2-Tab Segmented Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBE4DC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSegmentButton(
                          label: isArabic ? 'الطلبات الحية والكاونتر' : 'Live KDS Orders',
                          icon: Icons.receipt_long_rounded,
                          countBadge: allOrders.where((o) => o.status != OrderStatus.completed).length,
                          isSelected: _selectedTab == 0,
                          onTap: () => setState(() => _selectedTab = 0),
                        ),
                      ),
                      Expanded(
                        child: _buildSegmentButton(
                          label: isArabic ? 'المخزون وحالة التوفر' : 'Menu & Stock',
                          icon: Icons.inventory_2_rounded,
                          countBadge: cafe.menu.where((p) => !p.isAvailable).length,
                          badgeColor: AppColors.error,
                          isSelected: _selectedTab == 1,
                          onTap: () => setState(() => _selectedTab = 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Tab Body
              Expanded(
                child: _selectedTab == 0
                    ? _buildOrdersTab(
                        context: context,
                        appState: appState,
                        isArabic: isArabic,
                        allOrders: allOrders,
                        filteredOrders: filteredOrders,
                      )
                    : _buildMenuStockTab(
                        context: context,
                        appState: appState,
                        isArabic: isArabic,
                        cafeId: cafeId,
                        allCafeProducts: cafe.menu,
                        menuItems: menuItems,
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: _selectedTab == 1
            ? FloatingActionButton.extended(
                onPressed: () => _showAddProductModal(context, appState, cafeId),
                backgroundColor: AppColors.deepRoast,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add_rounded, color: AppColors.caramelAccent),
                label: Text(
                  isArabic ? 'إضافة صنف' : 'Add Item',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : null,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Shift Header Widget (Floating Dashboard Card with Margins & Rounded Corners)
  // ---------------------------------------------------------------------------
  Widget _buildShiftHeader({
    required BuildContext context,
    required AppState appState,
    required bool isArabic,
    required String cafeName,
    required double todayCash,
    required int totalOrdersCount,
    required int stampsGiven,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deepRoast,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x35000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Brand Logo, Café Name, Subtitle, & Logout Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cafe Brand Icon
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.caramelAccent.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.caramelAccent, width: 1.8),
                ),
                child: const Center(
                  child: Icon(Icons.local_cafe_rounded, color: AppColors.caramelAccent, size: 23),
                ),
              ),
              const SizedBox(width: 12),

              // Title and Subtitle Hierarchy
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            cafeName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32).withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF4CAF50), width: 0.8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5.5,
                                height: 5.5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isArabic ? 'مفتوح للطلبات' : 'Open',
                                style: const TextStyle(color: Color(0xFF81C784), fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isArabic ? 'كاونتر الباريستا والطلبات الحية' : 'Barista & Kitchen POS',
                      style: const TextStyle(
                        color: Color(0xFFD4C7B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Logout / Switch Account Button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      title: Text(isArabic ? 'تبديل الحساب' : 'Switch Account'),
                      content: Text(
                        isArabic
                            ? 'هل تريد العودة لتطبيق الزبائن أو تسجيل الخروج؟'
                            : 'Do you want to switch back to customer view or log out?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            appState.logout();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                          child: Text(isArabic ? 'خروج' : 'Log Out', style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout_rounded, color: Color(0xFFD4C7B8), size: 22),
                tooltip: isArabic ? 'تسجيل الخروج' : 'Log Out',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row 2: Prominent Wide Fast QR Stamp Button (Fitts's Law compliant for fast barista tapping)
          PressableScale(
            onTap: () => _showScanQrDialog(appState),
            child: Container(
              width: double.infinity,
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.caramelAccent,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.caramelAccent.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'مسح QR كود الزبون وختم كوب ولاء (+1)' : 'Scan Customer QR & Stamp (+1)',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Row 3: Shift Statistics Strip (Comfortable Margins and Generous Internal Padding)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF24140E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF3D251A), width: 1.2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildShiftStatItem(
                    label: isArabic ? 'كاش اليوم' : "Today's Cash",
                    value: '${todayCash.toStringAsFixed(0)} ج.م',
                    icon: Icons.payments_rounded,
                    iconColor: const Color(0xFF81C784),
                  ),
                ),
                Container(width: 1, height: 32, color: const Color(0xFF3D251A)),
                Expanded(
                  child: _buildShiftStatItem(
                    label: isArabic ? 'أوردرات اليوم' : "Orders",
                    value: '$totalOrdersCount ${isArabic ? 'طلب' : ''}',
                    icon: Icons.shopping_bag_rounded,
                    iconColor: AppColors.caramelAccent,
                  ),
                ),
                Container(width: 1, height: 32, color: const Color(0xFF3D251A)),
                Expanded(
                  child: _buildShiftStatItem(
                    label: isArabic ? 'أكواب مختومة' : "Stamps",
                    value: '$stampsGiven ${isArabic ? 'كوب' : ''}',
                    icon: Icons.local_cafe_rounded,
                    iconColor: const Color(0xFFFFB74D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF9E8E7E), fontSize: 10.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 1),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w900)),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required IconData icon,
    required int countBadge,
    Color badgeColor = AppColors.caramelAccent,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.deepRoast : AppColors.coffeeMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                color: isSelected ? AppColors.deepRoast : AppColors.coffeeMuted,
              ),
            ),
            if (countBadge > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected ? badgeColor : const Color(0xFFD4C7B8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$countBadge',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: Live Orders KDS
  // ---------------------------------------------------------------------------
  Widget _buildOrdersTab({
    required BuildContext context,
    required AppState appState,
    required bool isArabic,
    required List<OrderModel> allOrders,
    required List<OrderModel> filteredOrders,
  }) {
    return Column(
      children: [
        // Filter Status Pills Strip
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusFilterChip(
                  label: isArabic ? 'الكل' : 'All',
                  count: allOrders.length,
                  isSelected: _selectedOrderStatusFilter == null,
                  onTap: () => setState(() => _selectedOrderStatusFilter = null),
                ),
                const SizedBox(width: 6),
                _buildStatusFilterChip(
                  label: isArabic ? 'جديدة' : 'New',
                  count: allOrders.where((o) => o.status == OrderStatus.received).length,
                  isSelected: _selectedOrderStatusFilter == OrderStatus.received,
                  chipColor: const Color(0xFFE65100),
                  onTap: () => setState(() => _selectedOrderStatusFilter = OrderStatus.received),
                ),
                const SizedBox(width: 6),
                _buildStatusFilterChip(
                  label: isArabic ? 'قيد التحضير' : 'In Prep',
                  count: allOrders.where((o) => o.status == OrderStatus.preparing).length,
                  isSelected: _selectedOrderStatusFilter == OrderStatus.preparing,
                  chipColor: const Color(0xFF0277BD),
                  onTap: () => setState(() => _selectedOrderStatusFilter = OrderStatus.preparing),
                ),
                const SizedBox(width: 6),
                _buildStatusFilterChip(
                  label: isArabic ? 'جاهزة للتسليم' : 'Ready',
                  count: allOrders.where((o) => o.status == OrderStatus.ready).length,
                  isSelected: _selectedOrderStatusFilter == OrderStatus.ready,
                  chipColor: const Color(0xFF2E7D32),
                  onTap: () => setState(() => _selectedOrderStatusFilter = OrderStatus.ready),
                ),
                const SizedBox(width: 6),
                _buildStatusFilterChip(
                  label: isArabic ? 'المكتملة' : 'Completed',
                  count: allOrders.where((o) => o.status == OrderStatus.completed).length,
                  isSelected: _selectedOrderStatusFilter == OrderStatus.completed,
                  chipColor: AppColors.coffeeMuted,
                  onTap: () => setState(() => _selectedOrderStatusFilter = OrderStatus.completed),
                ),
              ],
            ),
          ),
        ),

        // Live Search by Customer Name / Order #
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFECE6DD)),
            ),
            child: TextField(
              controller: _orderSearchController,
              onChanged: (val) => setState(() => _orderSearchQuery = val),
              decoration: InputDecoration(
                hintText: isArabic ? 'بحث برقم الطلب (#1043) أو اسم الزبون أو الهاتف...' : 'Search order #, customer, phone...',
                hintStyle: const TextStyle(fontSize: 12, color: AppColors.coffeeMuted),
                prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.coffeeMuted),
                suffixIcon: _orderSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 16),
                        onPressed: () {
                          _orderSearchController.clear();
                          setState(() => _orderSearchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Orders List
        Expanded(
          child: filteredOrders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.coffee_maker_outlined, size: 54, color: AppColors.coffeeMuted.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Text(
                        isArabic ? 'لا توجد طلبات في هذا القسم حالياً' : 'No orders found in this section',
                        style: const TextStyle(color: AppColors.coffeeMuted, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                  itemCount: filteredOrders.length,
                  itemBuilder: (ctx, index) {
                    final order = filteredOrders[index];
                    return FadeSlideTransition(
                      delay: Duration(milliseconds: index * 40),
                      child: _buildOrderKdsCard(
                        context: context,
                        appState: appState,
                        isArabic: isArabic,
                        order: order,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatusFilterChip({
    required String label,
    required int count,
    required bool isSelected,
    Color? chipColor,
    required VoidCallback onTap,
  }) {
    final color = chipColor ?? AppColors.deepRoast;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2DAD0),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.deepRoast,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.25) : const Color(0xFFF0EAE2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.deepRoast,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card: Order KDS Item (Comfortable Spacing and Easy Visual Scanning)
  // ---------------------------------------------------------------------------
  Widget _buildOrderKdsCard({
    required BuildContext context,
    required AppState appState,
    required bool isArabic,
    required OrderModel order,
  }) {
    Color statusBadgeColor;
    String statusLabel;
    IconData statusIcon;

    switch (order.status) {
      case OrderStatus.received:
        statusBadgeColor = const Color(0xFFE65100);
        statusLabel = isArabic ? 'طلب جديد' : 'New Order';
        statusIcon = Icons.fiber_new_rounded;
        break;
      case OrderStatus.preparing:
        statusBadgeColor = const Color(0xFF0277BD);
        statusLabel = isArabic ? 'قيد التحضير' : 'Preparing';
        statusIcon = Icons.hourglass_top_rounded;
        break;
      case OrderStatus.ready:
        statusBadgeColor = const Color(0xFF2E7D32);
        statusLabel = isArabic ? 'جاهز للتسليم' : 'Ready';
        statusIcon = Icons.notifications_active_rounded;
        break;
      case OrderStatus.completed:
        statusBadgeColor = const Color(0xFF757575);
        statusLabel = isArabic ? 'تم التسليم' : 'Completed';
        statusIcon = Icons.check_circle_rounded;
        break;
    }

    final elapsedMins = DateTime.now().difference(order.createdAt).inMinutes;
    final timeStr = elapsedMins <= 0
        ? (isArabic ? 'الآن' : 'Just now')
        : (isArabic ? 'منذ $elapsedMins د' : '$elapsedMins min ago');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: order.status == OrderStatus.received
              ? const Color(0xFFFFB74D)
              : const Color(0xFFECE6DD),
          width: order.status == OrderStatus.received ? 1.8 : 1.0,
        ),
        boxShadow: AppDecorations.softCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: statusBadgeColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: AppColors.deepRoast,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#${order.id}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  timeStr,
                  style: const TextStyle(color: AppColors.coffeeMuted, fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: statusBadgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFFFFF4E8),
                      child: Text(
                        order.customerName.isNotEmpty ? order.customerName[0] : 'ع',
                        style: const TextStyle(color: AppColors.deepRoast, fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.deepRoast),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${order.customerPhone} • ${order.orderType}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.coffeeMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isArabic ? 'جاري الاتصال بالعميل: ${order.customerPhone}' : 'Calling ${order.customerPhone}...'),
                            backgroundColor: AppColors.deepRoast,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.caramelAccent, size: 21),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),

                const Divider(height: 22, color: Color(0xFFF0EAE2)),

                // Items List (Clean Spacing for Fast Scanning & Explicit Discounts)
                ...order.items.map((cartItem) {
                  final isFree = cartItem.isFreeReward;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isFree
                                ? const Color(0xFFFFF4E8)
                                : const Color(0xFFF3ECE4),
                            borderRadius: BorderRadius.circular(6),
                            border: isFree ? Border.all(color: AppColors.caramelAccent, width: 0.8) : null,
                          ),
                          child: Text(
                            '${cartItem.quantity}x',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              color: isFree ? AppColors.caramelAccent : AppColors.deepRoast,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      cartItem.product.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.deepRoast),
                                    ),
                                  ),
                                  if (isFree) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: const Color(0xFF81C784), width: 0.8),
                                      ),
                                      child: Text(
                                        isArabic ? '🎁 مجاني بالكامل' : '🎁 Free Cup',
                                        style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              if (cartItem.discountLabel != null && !isFree) ...[
                                const SizedBox(height: 2),
                                Text(
                                  '🏷️ ${cartItem.discountLabel}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFFE65100), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isFree) ...[
                              Text(
                                '${(cartItem.product.price * cartItem.quantity).toStringAsFixed(0)} ج.م',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.coffeeMuted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const Text(
                                '0 ج.م مجاني',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: Color(0xFF2E7D32)),
                              ),
                            ] else ...[
                              Text(
                                '${(cartItem.product.price * cartItem.quantity).toStringAsFixed(0)} ج.م',
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.deepRoast),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                // Explicit Discount & Free Reward System Callout (Transparent Reason & Scope)
                if (order.discount > 0 || order.discountReason != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFC8E6C9), width: 1.1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.redeem_rounded, color: Color(0xFF2E7D32), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.discountReason ?? (isArabic ? 'كوبون ولاء / خصم معتمد في السيستم' : 'Loyalty Reward / Approved Discount'),
                                style: const TextStyle(fontSize: 12, color: Color(0xFF1B5E20), fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isArabic
                                    ? 'قيمة الخصم: -${order.discount.toStringAsFixed(0)} ج.م ${order.discountedItemName != null ? 'على (${order.discountedItemName})' : ''}'
                                    : 'Discount amount: -${order.discount.toStringAsFixed(0)} EGP ${order.discountedItemName != null ? 'on (${order.discountedItemName})' : ''}',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF388E3C), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Customer Notes if available (Clean Callout Box)
                if (order.customerNotes != null && order.customerNotes!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9E6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFFE082), width: 1.1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.speaker_notes_outlined, color: Color(0xFFF57F17), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${isArabic ? 'ملاحظة العميل: ' : 'Note: '}${order.customerNotes}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF5D4037), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // Financial Breakdown & Cash to Collect
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF8F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFECE6DD)),
                  ),
                  child: Column(
                    children: [
                      if (order.discount > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isArabic ? 'إجمالي الأصناف قبل الخصم:' : 'Subtotal before discount:',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.coffeeMuted),
                            ),
                            Text(
                              '${order.subtotal.toStringAsFixed(0)} ج.م',
                              style: const TextStyle(fontSize: 12, color: AppColors.coffeeMuted, decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isArabic ? 'الخصم المطبق في السيستم:' : 'Discount applied:',
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '-${order.discount.toStringAsFixed(0)} ج.م',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF2E7D32), fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        const Divider(height: 12, color: Color(0xFFECE6DD)),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.total == 0
                                ? (isArabic ? 'المطلوب كاش: 0 ج.م (كوب مجاني 🎁)' : 'Collect Cash: 0 EGP (Free Cup 🎁)')
                                : '${isArabic ? 'المطلوب تحصيله كاش: ' : 'Collect Cash: '}${order.total.toStringAsFixed(0)} ج.م',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13.5,
                              color: order.total == 0 ? const Color(0xFF2E7D32) : AppColors.deepRoast,
                            ),
                          ),
                          Text(
                            order.paymentMethod,
                            style: const TextStyle(fontSize: 11, color: AppColors.coffeeMuted, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 1-Tap Workflow Transition Buttons
                _buildOrderActionButton(
                  context: context,
                  appState: appState,
                  isArabic: isArabic,
                  order: order,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderActionButton({
    required BuildContext context,
    required AppState appState,
    required bool isArabic,
    required OrderModel order,
  }) {
    switch (order.status) {
      case OrderStatus.received:
        return SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: () {
              appState.updateCafeOrderStatus(order.id, OrderStatus.preparing);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? '⚡ بدأ الباريستا في تحضير الطلب #${order.id}' : 'Started preparing order #${order.id}'),
                  backgroundColor: const Color(0xFF0277BD),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE65100),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flash_on_rounded, size: 19),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'بدء التحضير في المطبخ ⚡' : 'Start Preparing ⚡',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                ),
              ],
            ),
          ),
        );

      case OrderStatus.preparing:
        return SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: () {
              appState.updateCafeOrderStatus(order.id, OrderStatus.ready);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? '🔔 الطلب #${order.id} جاهز وتم إشعار العميل!' : 'Order #${order.id} is ready! Customer notified.'),
                  backgroundColor: const Color(0xFF2E7D32),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0277BD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_active_rounded, size: 19),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'الطلب جاهز للتسليم 🔔' : 'Order Ready for Pickup 🔔',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                ),
              ],
            ),
          ),
        );

      case OrderStatus.ready:
        return SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: () {
              appState.updateCafeOrderStatus(order.id, OrderStatus.completed);
              appState.recordCustomerStamp(cafeId: order.cafeId, phone: order.customerPhone, cups: 1);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? '🎉 تم تسليم الطلب #${order.id} وإضافة كوب ولاء لحساب العميل!'
                        : 'Order #${order.id} delivered & loyalty stamp recorded!',
                  ),
                  backgroundColor: AppColors.deepRoast,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_rounded, size: 19),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'تم التسليم والمحاسبة (+1 كوب للعميل) ✅' : 'Complete & Stamp Cup (+1) ✅',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                ),
              ],
            ),
          ),
        );

      case OrderStatus.completed:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F8E9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFC8E6C9)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_rounded, color: Color(0xFF2E7D32), size: 17),
              const SizedBox(width: 6),
              Text(
                isArabic ? 'طلب مكتمل ومُسلَّم بنجاح ✨' : 'Order Completed Successfully ✨',
                style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
            ],
          ),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // TAB 2: Menu & Stock (Instant 86 Out-of-Stock Management for Barista)
  // ---------------------------------------------------------------------------
  Widget _buildMenuStockTab({
    required BuildContext context,
    required AppState appState,
    required bool isArabic,
    required String cafeId,
    required List<Product> allCafeProducts,
    required List<Product> menuItems,
  }) {
    final categories = ['الكل', 'مشروبات باردة', 'قهوة مختصة', 'إسبريسو وحليب', 'مخبوزات وحلويات'];
    final outOfStockCount = allCafeProducts.where((p) => !p.isAvailable).length;

    return Column(
      children: [
        // Quick 86 Action Bar for Barista / Cashier
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
          child: Row(
            children: [
              Expanded(
                child: PressableScale(
                  onTap: () => _showQuick86Modal(context, appState, allCafeProducts),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFFB74D), width: 1.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.flash_on_rounded, color: Color(0xFFE65100), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isArabic ? 'لوحة النواقص السريعة (86 Quick Out of Stock)' : '86 Quick Out of Stock Sheet',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFFE65100)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE65100),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$outOfStockCount ${isArabic ? 'نافذ' : '86ed'}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Filter Only Out of Stock Toggle
              GestureDetector(
                onTap: () => setState(() => _onlyShowOutOfStock = !_onlyShowOutOfStock),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  decoration: BoxDecoration(
                    color: _onlyShowOutOfStock ? AppColors.error : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _onlyShowOutOfStock ? AppColors.error : const Color(0xFFECE6DD)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_list_rounded,
                        size: 16,
                        color: _onlyShowOutOfStock ? Colors.white : AppColors.deepRoast,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'النواقص فقط' : '86ed Only',
                        style: TextStyle(
                          color: _onlyShowOutOfStock ? Colors.white : AppColors.deepRoast,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Category Chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = _selectedMenuCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedMenuCategory = cat),
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.deepRoast,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.deepRoast,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Search in menu
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFECE6DD)),
            ),
            child: TextField(
              controller: _menuSearchController,
              onChanged: (val) => setState(() => _menuSearchQuery = val),
              decoration: InputDecoration(
                hintText: isArabic ? 'ابحث في أصناف المنيو: سبانش، كورتادو، كوكيز...' : 'Search menu items...',
                hintStyle: const TextStyle(fontSize: 12, color: AppColors.coffeeMuted),
                prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.coffeeMuted),
                suffixIcon: _menuSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 16),
                        onPressed: () {
                          _menuSearchController.clear();
                          setState(() => _menuSearchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        // Product Items List
        Expanded(
          child: menuItems.isEmpty
              ? Center(
                  child: Text(
                    isArabic ? 'لم يتم العثور على أصناف مطابقة للبحث' : 'No items match your search',
                    style: const TextStyle(color: AppColors.coffeeMuted, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 90),
                  itemCount: menuItems.length,
                  itemBuilder: (ctx, index) {
                    final item = menuItems[index];
                    return FadeSlideTransition(
                      delay: Duration(milliseconds: index * 30),
                      child: _buildProductStockCard(
                        context: context,
                        appState: appState,
                        isArabic: isArabic,
                        product: item,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Card: Product with 1-Tap Out of Stock Switch
  // ---------------------------------------------------------------------------
  Widget _buildProductStockCard({
    required BuildContext context,
    required AppState appState,
    required bool isArabic,
    required Product product,
  }) {
    final isAvailable = product.isAvailable;

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.white : const Color(0xFFF9F6F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isAvailable ? const Color(0xFFECE6DD) : const Color(0xFFFFCDD2),
          width: isAvailable ? 1.0 : 1.3,
        ),
        boxShadow: isAvailable ? AppDecorations.softCardShadow : null,
      ),
      child: Row(
        children: [
          // Thumbnail with Out of Stock overlay if disabled
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColorFiltered(
                  colorFilter: isAvailable
                      ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                      : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  child: Image.network(
                    product.image ?? '',
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 58,
                      height: 58,
                      color: const Color(0xFFEBE4DC),
                      child: const Icon(Icons.coffee, color: AppColors.deepRoast),
                    ),
                  ),
                ),
              ),
              if (!isAvailable)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.block_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: isAvailable ? AppColors.deepRoast : const Color(0xFF8D6E63),
                    decoration: isAvailable ? null : TextDecoration.lineThrough,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${product.price.toStringAsFixed(0)} ج.م • ${product.category}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.caramelAccent),
                ),
                const SizedBox(height: 5),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: isAvailable ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isAvailable ? (isArabic ? 'متوفر للطلب الآن ✅' : 'In Stock') : (isArabic ? 'غير متوفر - نفذ من المخزون ❌' : 'Out of Stock'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isAvailable ? const Color(0xFF2E7D32) : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Quick Edit button
          IconButton(
            onPressed: () => _showQuickEditProductModal(context, appState, product),
            icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.coffeeMuted),
            tooltip: isArabic ? 'تعديل السعر والبيانات' : 'Edit details',
          ),

          // 1-Tap Out of Stock Toggle Switch
          Switch.adaptive(
            value: isAvailable,
            activeTrackColor: const Color(0xFF2E7D32),
            activeThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFEF9A9A),
            inactiveThumbColor: AppColors.error,
            onChanged: (bool val) {
              appState.toggleProductAvailability(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    val
                        ? (isArabic ? 'أصبح (${product.name}) متوفراً للزبائن الآن ✅' : '${product.name} is now In Stock')
                        : (isArabic ? 'تم تحويل (${product.name}) إلى نفذ من المخزون ❌' : '${product.name} marked Out of Stock'),
                  ),
                  backgroundColor: val ? AppColors.deepRoast : const Color(0xFFC62828),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
