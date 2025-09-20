import 'package:flutter/material.dart';
import 'package:bazar_marketplace_app/utils/bazar_theme.dart';
import 'dart:ui';

class BazarBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BazarBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.widgets_outlined,
                  selectedIcon: Icons.widgets,
                  label: 'Categories',
                  index: 1,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.shopping_cart_outlined,
                  selectedIcon: Icons.shopping_cart,
                  label: 'Cart',
                  index: 2,
                  showBadge: true,
                  badgeCount: 3,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.favorite_outline,
                  selectedIcon: Icons.favorite,
                  label: 'Wishlist',
                  index: 3,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Profile',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    final isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..scale(isSelected ? 1.1 : 1.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? selectedIcon : icon,
                    color: isSelected
                        ? BazarTheme.primaryGreen
                        : BazarTheme.textSecondary,
                    size: 26,
                  ),
                  if (showBadge && badgeCount > 0)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: BazarTheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            badgeCount > 9 ? '9+' : badgeCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: isSelected
                        ? BazarTheme.primaryGreen
                        : BazarTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}