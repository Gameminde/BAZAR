/*
 * Glassmorphic AppBar Simple - BAZAR 2025
 * Version simple pour intégration immédiate
 */

import 'package:flutter/material.dart';
import 'dart:ui';
// import '../utils/bazar_glassmorphism_theme.dart'; // Fichier supprimé

class GlassmorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const GlassmorphicAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Leading widget (back button, menu, etc.)
                if (leading != null) ...[leading!, const SizedBox(width: 16)],

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Actions
                if (actions != null) ...[
                  const SizedBox(width: 16),
                  ...actions!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
