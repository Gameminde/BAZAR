/*
 *   BAZAR Marketplace
 *   @package BAZAR Application Code.
 *   @Category Marketplace
 *   @author BAZAR Team
 *   @Copyright (c) 2025 BAZAR Marketplace
 *   @license MIT License
 *   @link https://bazar.marketplace.com
 */

import 'package:flutter/foundation.dart';
import 'package:bazar_marketplace_app/screens/splash_screen/utils/index.dart';
import 'package:bazar_marketplace_app/utils/bazar_theme.dart';
import 'package:bazar_marketplace_app/utils/bazar_colors.dart';

import '../../../utils/prefetching_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigateHomepage();
    preCacheCMSData();
    preCacheLanguageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BazarColors.primaryBlue,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [BazarColors.primaryBlue, BazarColors.secondaryGold],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo BAZAR
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.store,
                  size: 60,
                  color: BazarColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 30),

              // Nom de l'application
              const Text(
                'BAZAR',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              const Text(
                'Your Ultimate Marketplace',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 50),

              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navigateHomepage() async {
    // Gestion spécifique pour le web
    if (kIsWeb) {
      appDocPath = 'web_storage';
    } else {
      try {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        appDocPath = appDocDir.path;
      } catch (e) {
        // Fallback pour les erreurs path_provider
        appDocPath = 'fallback_storage';
      }
    }

    Timer(const Duration(seconds: defaultSplashDelay), () {
      Navigator.pushReplacementNamed(context, home);
    });
  }
}
