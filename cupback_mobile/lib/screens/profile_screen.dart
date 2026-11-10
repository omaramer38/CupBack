import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/state/app_state.dart';
import '../core/widgets/fade_slide_transition.dart';
import '../core/widgets/pressable_scale.dart';
import 'order_tracking_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  void _showLogoutDialog(BuildContext context, AppState appState, bool isArabic) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'تسجيل الخروج' : 'Log Out',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.deepRoast),
            ),
          ],
        ),
        content: Text(
          isArabic
              ? 'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟'
              : 'Are you sure you want to log out of your account?',
          style: const TextStyle(fontSize: 13, color: AppColors.deepRoast),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel', style: const TextStyle(color: AppColors.coffeeMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              appState.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(isArabic ? 'تأكيد الخروج' : 'Confirm Logout'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileModal(
    BuildContext context,
    AppState appState,
    bool isArabic,
    String currentName,
    String currentPhone,
  ) {
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.caramelAccent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_rounded, color: AppColors.caramelAccent, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.deepRoast,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                isArabic ? 'الاسم الكامل' : 'Full Name',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFAF8F5),
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.deepRoast, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE8E0D5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE8E0D5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.caramelAccent, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isArabic ? 'رقم الهاتف المحمول' : 'Phone Number',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.deepRoast),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFAF8F5),
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.deepRoast, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE8E0D5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE8E0D5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.caramelAccent, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final newName = nameController.text.trim();
                    final newPhone = phoneController.text.trim();
                    if (newName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isArabic ? 'يرجى إدخال اسمك' : 'Please enter your name'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    appState.updateUserProfile(name: newName, phone: newPhone);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isArabic ? 'تم تحديث بياناتك بنجاح ✅' : 'Profile updated successfully ✅',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        backgroundColor: AppColors.deepRoast,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final strings = appState.strings;
    final session = appState.session;
    final isArabic = strings.isArabic;

    final userName = session?.name.isNotEmpty == true
        ? session!.name
        : (isArabic ? 'أحمد محمود' : 'Ahmed Mahmoud');
    final userPhone = session?.phone.isNotEmpty == true
        ? session!.phone
        : '01012345678';

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isArabic ? 'الملف الشخصي' : 'Profile',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: AppColors.deepRoast,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.deepRoast, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? 'لديك إشعار جديد: عرض 20% في كافيه الزيتون!' : 'New offer: 20% off at Zeitoun!'),
                  backgroundColor: AppColors.deepRoast,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // 1. User Info Header Row
            FadeSlideTransition(
              delay: const Duration(milliseconds: 50),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFECA062), Color(0xFFD87D38)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.caramelAccent.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFFFFF4E8),
                      child: Text(
                        userName.isNotEmpty ? userName[0] : 'أ',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.deepRoast,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.deepRoast,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userPhone,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.coffeeMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PressableScale(
                    scaleFactor: 0.92,
                    onTap: () => _showEditProfileModal(context, appState, isArabic, userName, userPhone),
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFECE6DD)),
                        boxShadow: AppDecorations.softCardShadow,
                      ),
                      child: Center(
                        child: Text(
                          isArabic ? 'تعديل' : 'Edit',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepRoast,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 3. Three Quick Stats Cards
            FadeSlideTransition(
              delay: const Duration(milliseconds: 100),
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuickStatCard(
                      icon: Icons.local_mall_outlined,
                      label: isArabic ? 'الطلبات' : 'Orders',
                      value: appState.activeOrder != null
                          ? (isArabic ? '1 نشط' : '1 active')
                          : (isArabic ? 'لا يوجد' : 'None'),
                      color: const Color(0xFF6B4226),
                      onTap: () {
                        if (appState.activeOrder != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderTrackingScreen(order: appState.activeOrder!),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickStatCard(
                      icon: Icons.local_cafe_outlined,
                      label: isArabic ? 'أكوابي' : 'Stamps',
                      value: '${appState.getOrdersCountForCafe('cafe_1')} ${isArabic ? 'أكواب' : 'cups'}',
                      color: AppColors.caramelAccent,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickStatCard(
                      icon: Icons.favorite_border_rounded,
                      label: isArabic ? 'المفضلة' : 'Saved',
                      value: '${appState.favoriteCafeIds.length} ${isArabic ? 'كافيهات' : 'cafes'}',
                      color: const Color(0xFFB54738),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Grouped Settings Card
            FadeSlideTransition(
              delay: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFECE6DD)),
                  boxShadow: AppDecorations.softCardShadow,
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      icon: Icons.location_on_outlined,
                      title: isArabic ? 'الفروع والعناوين المحفوظة' : 'Saved Addresses',
                      trailingText: isArabic ? 'كفر الشيخ' : 'Kafr El Sheikh',
                      showDivider: true,
                      onTap: () {},
                    ),
                    _buildSettingsRow(
                      icon: Icons.payment_rounded,
                      title: isArabic ? 'طريقة الدفع' : 'Payment Method',
                      trailingText: isArabic ? 'كاش عند الاستلام' : 'Cash on Pickup',
                      showDivider: true,
                      onTap: () {},
                    ),
                    _buildSettingsRow(
                      icon: Icons.notifications_active_outlined,
                      title: isArabic ? 'الإشعارات' : 'Notifications',
                      trailingWidget: Switch.adaptive(
                        value: _notificationsEnabled,
                        activeThumbColor: AppColors.caramelAccent,
                        onChanged: (val) {
                          setState(() {
                            _notificationsEnabled = val;
                          });
                        },
                      ),
                      showDivider: true,
                    ),
                    _buildSettingsRow(
                      icon: Icons.language_rounded,
                      title: isArabic ? 'لغة التطبيق' : 'Language',
                      trailingText: isArabic ? 'العربية' : 'English',
                      showDivider: true,
                      onTap: () {
                        appState.toggleLanguage();
                      },
                    ),
                    _buildSettingsRow(
                      icon: Icons.help_outline_rounded,
                      title: isArabic ? 'المساعدة والدعم' : 'Help & Support',
                      showDivider: false,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isArabic ? 'فريق الدعم الفني لـ CupBack في خدمتك.' : 'CupBack support team is here for you.'),
                            backgroundColor: AppColors.deepRoast,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 5. Log Out Button
            FadeSlideTransition(
              delay: const Duration(milliseconds: 250),
              child: Center(
                child: PressableScale(
                  scaleFactor: 0.95,
                  onTap: () => _showLogoutDialog(context, appState, isArabic),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
                        const SizedBox(width: 6),
                        Text(
                          isArabic ? 'تسجيل الخروج' : 'Log Out',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return PressableScale(
      scaleFactor: 0.94,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFECE6DD)),
          boxShadow: AppDecorations.softCardShadow,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.coffeeMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w900,
                color: AppColors.deepRoast,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? trailingWidget,
    required bool showDivider,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          leading: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.deepRoast, size: 19),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.deepRoast,
            ),
          ),
          trailing: trailingWidget ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (trailingText != null)
                    Text(
                      trailingText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.coffeeMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 19,
                    color: Color(0xFFB0A296),
                  ),
                ],
              ),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 54,
            endIndent: 16,
            color: Color(0xFFF1ECE4),
          ),
      ],
    );
  }
}
