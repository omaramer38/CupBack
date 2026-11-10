import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/state/app_state.dart';
import '../core/widgets/pressable_scale.dart';
import 'home_screen.dart';
import 'offers_screen.dart';
import 'rewards_screen.dart';
import 'cafes_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.maybeOf(context);
    final isArabic = appState?.strings.isArabic ?? true;

    final screens = [
      HomeScreen(
        onNavigateToOffers: () => _navigateToTab(1),
        onNavigateToRewards: () => _navigateToTab(2),
      ),
      const OffersScreen(),
      const RewardsScreen(),
      const CafesScreen(),
      const ProfileScreen(),
    ];

    final navItems = [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: isArabic ? 'الرئيسية' : 'Home',
      ),
      _NavItem(
        icon: Icons.local_offer_outlined,
        activeIcon: Icons.local_offer_rounded,
        label: isArabic ? 'العروض' : 'Offers',
      ),
      _NavItem(
        icon: Icons.card_giftcard_outlined,
        activeIcon: Icons.card_giftcard_rounded,
        label: isArabic ? 'المكافآت' : 'Rewards',
      ),
      _NavItem(
        icon: Icons.coffee_outlined,
        activeIcon: Icons.coffee_rounded,
        label: isArabic ? 'المقاهي' : 'Cafés',
      ),
      _NavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: isArabic ? 'حسابي' : 'Profile',
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 66,
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(33),
            border: Border.all(
              color: const Color(0xFFECE6DD),
              width: 1,
            ),
            boxShadow: AppDecorations.floatingNavShadow,
          ),
          child: Row(
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = _currentIndex == index;

              return Expanded(
                child: PressableScale(
                  scaleFactor: 0.94,
                  onTap: () => _navigateToTab(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFF3ECE4) // Soft pill background matching reference
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedScale(
                          scale: isSelected ? 1.08 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: isSelected
                                ? AppColors.deepRoast
                                : const Color(0xFF968273),
                            size: 21,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                            color: isSelected
                                ? AppColors.deepRoast
                                : const Color(0xFF968273),
                            height: 1.15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
