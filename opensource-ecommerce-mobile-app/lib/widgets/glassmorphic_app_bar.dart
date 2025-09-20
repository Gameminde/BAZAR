/*
 * Glassmorphic AppBar - BAZAR 2025
 * AppBar premium avec effets glassmorphism
 */

import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../utils/app_global_data.dart';
import '../utils/badge_helper.dart';
import '../utils/shared_preference_helper.dart';
import '../utils/route_constants.dart';
import 'glassmorphism/index.dart';

class GlassmorphicCommonAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final int? index;
  final bool isInCartScreen;
  final bool showGlassmorphism;

  const GlassmorphicCommonAppBar(
    this.title, {
    Key? key,
    this.index,
    this.isInCartScreen = false,
    this.showGlassmorphism = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showGlassmorphism) {
      return GlassmorphicAppBar(
        title: title,
        actions: _buildGlassmorphicActions(context),
        showBackButton: false,
      );
    } else {
      return AppBar(
        elevation: 4,
        centerTitle: false,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.spacingLarge,
          ),
        ),
        actions: _buildStandardActions(context),
      );
    }
  }

  List<Widget> _buildGlassmorphicActions(BuildContext context) {
    return [
      GlassmorphicIconButton(
        icon: Icons.search,
        onPressed: () {
          if (index != 0) {
            Navigator.pushNamed(context, searchScreen);
          }
        },
      ),
      const SizedBox(width: 8),
      GlassmorphicIconButton(
        icon: Icons.compare_arrows,
        onPressed: () {
          if (index != 1) {
            Navigator.pushNamed(context, compareScreen);
          }
        },
      ),
      const SizedBox(width: 8),
      StreamBuilder(
        stream: GlobalData.cartCountController.stream,
        builder: (BuildContext context, snapshot) {
          int count = snapshot.data ?? 0;
          return BadgeIcon(
            badgeCount: count,
            icon: GlassmorphicIconButton(
              icon: Icons.shopping_bag_outlined,
              onPressed: () {
                if (index != 2) {
                  Navigator.pushNamed(context, cartScreen);
                }
              },
            ),
          );
        },
      ),
    ];
  }

  List<Widget> _buildStandardActions(BuildContext context) {
    return [
      if (!isInCartScreen)
        IconButton(
          onPressed: () {
            if (index != 0) {
              Navigator.pushNamed(context, searchScreen);
            }
          },
          icon: const Icon(Icons.search),
        ),
      if (!isInCartScreen)
        IconButton(
          onPressed: () {
            if (index != 1) {
              Navigator.pushNamed(context, compareScreen);
            }
          },
          icon: const Icon(Icons.compare_arrows),
        ),
      if (!isInCartScreen)
        StreamBuilder(
          stream: GlobalData.cartCountController.stream,
          builder: (BuildContext context, snapshot) {
            int count = snapshot.data ?? 0;

            appStoragePref.setCartCount(count);
            return BadgeIcon(
              badgeCount: count,
              icon: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {
                  if (index != 2) {
                    Navigator.pushNamed(context, cartScreen);
                  }
                },
              ),
            );
          },
        ),
    ];
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

/// Variante compacte pour les écrans secondaires
class GlassmorphicCompactAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const GlassmorphicCompactAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CompactGlassmorphicAppBar(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

/// Variante animée avec particules
class GlassmorphicAnimatedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const GlassmorphicAnimatedAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedGlassmorphicAppBar(
      title: title,
      actions: actions,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}

/// Extension pour convertir CommonAppBar en GlassmorphicAppBar
extension GlassmorphicAppBarExtension on AppBar {
  GlassmorphicAppBar toGlassmorphic() {
    return GlassmorphicAppBar(
      title: (title as Text).data ?? '',
      actions: actions,
      showBackButton: leading != null,
    );
  }
}
