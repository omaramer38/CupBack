import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/state/app_state.dart';
import '../core/models/product.dart';
import '../core/models/cafe.dart';
import '../core/widgets/fade_slide_transition.dart';
import '../core/widgets/pressable_scale.dart';
import '../core/widgets/bouncing_cart_badge.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final Cafe cafe;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.cafe,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  late ProductOption _selectedSize;
  final Set<ProductOption> _selectedAddOns = {};
  late String _selectedSweetness;
  final _notesController = TextEditingController();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizeOptions.first;
    _selectedSweetness = widget.product.sweetnessOptions.first;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _currentUnitPrice {
    double total = widget.product.price + _selectedSize.extraPrice;
    for (final addOn in _selectedAddOns) {
      total += addOn.extraPrice;
    }
    return total;
  }

  double get _currentTotalPrice => _currentUnitPrice * _quantity;

  void _handleAddToCart(AppState appState) {
    appState.addToCart(
      widget.product,
      widget.cafe.name,
      quantity: _quantity,
      selectedSize: _selectedSize.name,
      selectedAddOns: _selectedAddOns.map((e) => e.name).toList(),
      selectedSweetness: _selectedSweetness,
      unitPrice: _currentUnitPrice,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'تمت إضافة $_quantity × ${widget.product.name} إلى السلة ☕',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.deepRoast,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        action: SnackBarAction(
          label: 'عرض السلة',
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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = appState.strings;
    final isArabic = strings.isArabic;
    final product = widget.product;
    final cafe = widget.cafe;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.deepRoast, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          product.name,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.deepRoast,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? AppColors.error : AppColors.deepRoast,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.deepRoast),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (appState.cartTotalItems > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: BouncingBadge(count: appState.cartTotalItems),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Product Photo with Rating & Category
            Hero(
              tag: 'product-img-${product.id}',
              child: Container(
                height: 220,
                width: double.infinity,
                color: const Color(0xFFF7F4EE),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (product.image != null && product.image!.isNotEmpty)
                      Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.coffee_rounded, size: 64, color: AppColors.deepRoast),
                        ),
                      )
                    else
                      const Center(
                        child: Icon(Icons.coffee_rounded, size: 64, color: AppColors.deepRoast),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              product.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.caramelAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 14, color: Colors.white),
                                const SizedBox(width: 3),
                                Text(
                                  '${cafe.rating}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Info Header (Cafe link & Product title & description)
            FadeSlideTransition(
              delay: const Duration(milliseconds: 100),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cafe pill
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 22,
                            height: 22,
                            color: const Color(0xFFF7F3ED),
                            child: cafe.logo != null
                                ? Image.network(cafe.logo!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.storefront, size: 13))
                                : const Icon(Icons.storefront, size: 13),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          cafe.name,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.caramelAccent,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.chevron_right_rounded, size: 15, color: AppColors.caramelAccent),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: AppColors.deepRoast,
                              height: 1.2,
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                          child: Text(
                            '${_currentUnitPrice.toStringAsFixed(0)} ج.م',
                            key: ValueKey<double>(_currentUnitPrice),
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: AppColors.caramelAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Ingredients & Description
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.deepRoast.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Info Badges Row (Calories, Prep Time, Loyalty Stamp)
                    Row(
                      children: [
                        _buildInfoBadge(Icons.timer_outlined, product.prepTime),
                        const SizedBox(width: 8),
                        _buildInfoBadge(Icons.local_fire_department_outlined, product.calories),
                        const SizedBox(width: 8),
                        _buildInfoBadge(Icons.card_giftcard_rounded, isArabic ? 'كوب ولاء' : 'Stamp +1'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Divider(thickness: 4, color: Color(0xFFFAF7F2)),

            // 3. Section: Size / Shot
            FadeSlideTransition(
              delay: const Duration(milliseconds: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: isArabic ? 'الحجم والشوت (Size)' : 'Size & Shots',
                    subtitle: isArabic ? 'إجباري • اختر 1' : 'Required • Pick 1',
                  ),
                  ...widget.product.sizeOptions.map((opt) {
                    final isSelected = _selectedSize.name == opt.name;
                    return PressableScale(
                      scaleFactor: 0.98,
                      onTap: () {
                        setState(() {
                          _selectedSize = opt;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFBF7F2) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.caramelAccent : const Color(0xFFECE6DD),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                              color: isSelected ? AppColors.caramelAccent : const Color(0xFFB0A296),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                opt.name,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: AppColors.deepRoast,
                                ),
                              ),
                            ),
                            if (opt.extraPrice > 0)
                              Text(
                                '+${opt.extraPrice.toStringAsFixed(0)} ج.م',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.caramelAccent,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const Divider(thickness: 4, color: Color(0xFFFAF7F2)),

            // 4. Section: Customization & Add-ons
            FadeSlideTransition(
              delay: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: isArabic ? 'الإضافات والتخصيص (Add-ons)' : 'Custom Add-ons',
                    subtitle: isArabic ? 'اختياري • تحكم في مكونات مشروبك' : 'Optional • Customize recipe',
                  ),
                  ...widget.product.addOnOptions.map((addOn) {
                    final isChecked = _selectedAddOns.contains(addOn);
                    return PressableScale(
                      scaleFactor: 0.98,
                      onTap: () {
                        setState(() {
                          if (isChecked) {
                            _selectedAddOns.remove(addOn);
                          } else {
                            _selectedAddOns.add(addOn);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isChecked ? const Color(0xFFFBF7F2) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isChecked ? AppColors.caramelAccent : const Color(0xFFECE6DD),
                            width: isChecked ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                              color: isChecked ? AppColors.caramelAccent : const Color(0xFFB0A296),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                addOn.name,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: isChecked ? FontWeight.w800 : FontWeight.w600,
                                  color: AppColors.deepRoast,
                                ),
                              ),
                            ),
                            if (addOn.extraPrice > 0)
                              Text(
                                '+${addOn.extraPrice.toStringAsFixed(0)} ج.م',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.caramelAccent,
                                ),
                              )
                            else
                              Text(
                                isArabic ? 'مجاناً' : 'Free',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const Divider(thickness: 4, color: Color(0xFFFAF7F2)),

            // 5. Section: Sweetness Level
            FadeSlideTransition(
              delay: const Duration(milliseconds: 250),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: isArabic ? 'درجة الحلاوة (Sweetness)' : 'Sweetness Level',
                    subtitle: isArabic ? 'اختر مستوى السكر' : 'Select sweetness',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.product.sweetnessOptions.map((opt) {
                        final isSelected = _selectedSweetness == opt;
                        return PressableScale(
                          scaleFactor: 0.94,
                          onTap: () {
                            setState(() {
                              _selectedSweetness = opt;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.deepRoast : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.deepRoast : const Color(0xFFECE6DD),
                              ),
                            ),
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.deepRoast,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 4, color: Color(0xFFFAF7F2)),

            // 6. Section: Special Instructions
            FadeSlideTransition(
              delay: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      title: isArabic ? 'ملاحظات خاصة للكافيه' : 'Special Instructions',
                      subtitle: isArabic ? 'اختياري' : 'Optional',
                    ),
                    TextField(
                      controller: _notesController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13, color: AppColors.deepRoast),
                      decoration: InputDecoration(
                        hintText: isArabic
                            ? 'مثال: رجاءً وضع حليب اللوز منفصل، الكوب ساخن جداً...'
                            : 'e.g. Extra hot, separate sleeve, no sugar...',
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9E8B7E)),
                        filled: true,
                        fillColor: const Color(0xFFFAF8F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFECE6DD)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFECE6DD)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.caramelAccent, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 7. Sticky Bottom Add to Cart Bar with Animations
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
          border: const Border(
            top: BorderSide(color: Color(0xFFECE6DD)),
          ),
        ),
        child: Row(
          children: [
            // Quantity Stepper: [ - 1 + ]
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECE6DD)),
              ),
              child: Row(
                children: [
                  PressableScale(
                    scaleFactor: 0.85,
                    onTap: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Icon(Icons.remove, size: 18, color: AppColors.deepRoast),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Text(
                      '$_quantity',
                      key: ValueKey<int>(_quantity),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.deepRoast,
                      ),
                    ),
                  ),
                  PressableScale(
                    scaleFactor: 0.85,
                    onTap: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Icon(Icons.add, size: 18, color: AppColors.deepRoast),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Big CTA Button: [ Add to Basket • XX ج.م ]
            Expanded(
              child: SizedBox(
                height: 48,
                child: PressableScale(
                  scaleFactor: 0.96,
                  onTap: () => _handleAddToCart(appState),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.deepRoast,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deepRoast.withValues(alpha: 0.28),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isArabic ? 'إضافة إلى السلة' : 'Add to Basket',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Text(
                            '• ${_currentTotalPrice.toStringAsFixed(0)} ج.م',
                            key: ValueKey<double>(_currentTotalPrice),
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w900,
                              color: AppColors.caramelLight,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildInfoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFECE6DD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.caramelAccent),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.deepRoast,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: AppColors.deepRoast,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.deepRoast.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
