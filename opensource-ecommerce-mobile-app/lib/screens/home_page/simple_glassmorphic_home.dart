/*
 * Simple Glassmorphic Home - BAZAR 2025
 * Version simplifiée pour intégration immédiate
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bazar_marketplace_app/screens/home_page/utils/index.dart';
import 'package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_components.dart';
// import 'package:bazar_marketplace_app/widgets/floating_particles_widget_basic.dart'; // Supprimé, maintenant dans glassmorphic_components.dart
// import 'package:bazar_marketplace_app/widgets/glassmorphic_appbar_simple.dart'; // Conflit avec glassmorphic_components.dart
// import 'package:bazar_marketplace_app/utils/bazar_glassmorphism_theme.dart'; // Fichier supprimé
import 'package:bazar_marketplace_app/utils/product_images.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SimpleGlassmorphicHome extends StatefulWidget {
  const SimpleGlassmorphicHome({Key? key}) : super(key: key);

  @override
  State<SimpleGlassmorphicHome> createState() => _SimpleGlassmorphicHomeState();
}

class _SimpleGlassmorphicHomeState extends State<SimpleGlassmorphicHome>
    with TickerProviderStateMixin {
  bool isLoggedIn = false, isLoading = false, callPreCache = true;
  String? customerUserName, image, customerLanguage, customerCurrency;
  HomePageBloc? homePageBloc;
  AddToCartModel? addToCartModel;
  // ThemeCustomDataModel? customHomeData;
  CurrencyLanguageList? currencyLanguageList;
  GetDrawerCategoriesData? getHomeCategoriesData;
  AccountInfoModel? customerDetails;
  DrawerBloc? drawerBloc;

  late AnimationController _heroController;
  late Animation<double> _heroAnimation;

  @override
  void initState() {
    super.initState();

    // Animation du hero
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();

    _heroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );

    _registerStreamListener();
    _fetchSharedPreferenceData();
    drawerBloc = context.read<DrawerBloc>();
    getCartCount().then((value) {
      GlobalData.cartCountController.sink.add(value);
    });
    customerLanguage = appStoragePref.getLanguageName();
    customerCurrency = appStoragePref.getCurrencyLabel();
    fetchHomepageData();
    fetchOfflineProductData();
    GlobalData.locale = appStoragePref.getCustomerLanguage();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  Future<int> getCartCount() async {
    return appStoragePref.getCartCount();
  }

  void _registerStreamListener() {
    // Logique de stream listener de HomeScreen original
  }

  void _fetchSharedPreferenceData() {
    // Logique de fetch shared preferences de HomeScreen original
  }

  void fetchHomepageData() {
    // Logique de fetch homepage data de HomeScreen original
  }

  void fetchOfflineProductData() {
    // Logique de fetch offline product data de HomeScreen original
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background avec gradient mesh
        _buildAnimatedBackground(),

        // Particules flottantes
        const FloatingParticlesWidget(),

        // Contenu principal
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: GlassmorphicAppBar(
            title: 'BAZAR MARKETPLACE',
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, searchScreen);
                },
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, cartScreen);
                },
              ),
            ],
          ),
          drawer: _drawerData(context), // RÉACTIVÉ !
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section glassmorphism
                _buildHeroSection(),

                // Categories glassmorphism
                _buildCategoriesSection(),

                // Featured Products glassmorphism
                _buildFeaturedProducts(),

                // Navigation vers tous les écrans pour test
                _buildNavigationTestSection(),

                // Bottom spacing
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E8), // Background green
            Color(0xFF4A7C59), // Primary green
            Color(0xFF5B8A67), // Secondary green
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) => Opacity(
        opacity: _heroAnimation.value,
        child: Transform.translate(
          offset: Offset(0, 50 * (1 - _heroAnimation.value)),
          child: Container(
            margin: const EdgeInsets.all(20),
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.store, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'Bienvenue sur BAZAR',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Découvrez des milliers de produits\nde qualité avec une expérience\nexceptionnelle',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Explorer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catégories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, index) => Container(
                width: 100,
                margin: const EdgeInsets.only(right: 16),
                child: GlassmorphicCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        width: 32,
                        height: 32,
                        imageUrl: ProductImages.getRandomImageForCategory(
                          'electronics',
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          child: const Icon(
                            Icons.category,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          child: const Icon(
                            Icons.category,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cat ${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Produits Vedettes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => GlassmorphicCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            ProductImages.getRandomProductImage(),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Produit ${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(index + 1) * 50}€',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF4A261), // Accent yellow
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section de navigation pour tester tous les écrans
  Widget _buildNavigationTestSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TESTER TOUS LES ÉCRANS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Écrans E-commerce
          _buildNavigationCategory('E-COMMERCE', [
            {
              'title': 'Produits',
              'route': categoryScreen,
              'icon': Icons.inventory,
            },
            {
              'title': 'Panier',
              'route': cartScreen,
              'icon': Icons.shopping_cart,
            },
            {
              'title': 'Commandes',
              'route': orderListScreen,
              'icon': Icons.receipt_long,
            },
            {
              'title': 'Favoris',
              'route': wishlistScreen,
              'icon': Icons.favorite,
            },
          ]),

          const SizedBox(height: 16),

          // Écrans Utilisateur
          _buildNavigationCategory('UTILISATEUR', [
            {'title': 'Connexion', 'route': signIn, 'icon': Icons.login},
            {'title': 'Inscription', 'route': signUp, 'icon': Icons.person_add},
            {
              'title': 'Profil',
              'route': accountInfo,
              'icon': Icons.account_circle,
            },
            {
              'title': 'Adresses',
              'route': addressList,
              'icon': Icons.location_on,
            },
          ]),

          const SizedBox(height: 16),

          // Écrans Fonctionnalités
          _buildNavigationCategory('FONCTIONNALITÉS', [
            {'title': 'Recherche', 'route': searchScreen, 'icon': Icons.search},
            {
              'title': 'Catégories',
              'route': categoryScreen,
              'icon': Icons.category,
            },
            {
              'title': 'Comparer',
              'route': compareScreen,
              'icon': Icons.compare,
            },
            {
              'title': 'Langues',
              'route': languageScreen,
              'icon': Icons.language,
            },
          ]),

          const SizedBox(height: 16),

          // Écrans Paramètres
          _buildNavigationCategory('PARAMÈTRES', [
            {
              'title': 'Devises',
              'route': currencyScreen,
              'icon': Icons.monetization_on,
            },
            {
              'title': 'Contact',
              'route': contactUsScreen,
              'icon': Icons.contact_support,
            },
            {
              'title': 'Dashboard',
              'route': dashboardScreen,
              'icon': Icons.dashboard,
            },
            {'title': 'GDPR', 'route': gdpr, 'icon': Icons.privacy_tip},
          ]),
        ],
      ),
    );
  }

  Widget _buildNavigationCategory(
    String title,
    List<Map<String, dynamic>> screens,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF4A261), // Accent color
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: screens.length,
          itemBuilder: (context, index) {
            final screen = screens[index];
            return GlassmorphicCard(
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () {
                  try {
                    // Navigation avec gestion d'arguments selon l'écran
                    if (screen['route'] == signUp) {
                      Navigator.pushNamed(
                        context,
                        screen['route'],
                        arguments: false,
                      );
                    } else {
                      Navigator.pushNamed(context, screen['route']);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Écran ${screen['title']} en développement',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Icon(screen['icon'], color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        screen['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  ///Drawer Bloc container
  _drawerData(BuildContext context) {
    return BlocConsumer<DrawerBloc, DrawerPageBaseState>(
      listener: (BuildContext context, DrawerPageBaseState state) {},
      builder: (BuildContext context, DrawerPageBaseState state) {
        if (state is FetchDrawerPageDataState) {
          if (state.status == DrawerStatus.success) {
            GlobalData.categoriesDrawerData = state.getCategoriesDrawerData;
            appStoragePref.setDrawerCategories(state.getCategoriesDrawerData);
          }
          drawerBloc?.add(CurrencyLanguageEvent());
        }
        if (state is FetchLanguageCurrencyState) {
          if (state.status == DrawerStatus.success) {
            GlobalData.rootCategoryId =
                state.currencyLanguageList?.rootCategoryId ?? 1;
            currencyLanguageList = state.currencyLanguageList;
            GlobalData.languageData = state.currencyLanguageList;
          }
        }

        return DrawerListView(
          isLoggedIn: isLoggedIn,
          customerUserName: customerUserName,
          image: image,
          customerCurrency: customerCurrency,
          currencyLanguageList: currencyLanguageList,
          customerDetails: customerDetails,
          customerLanguage: customerLanguage,
          loginCallback: (isLogged) {
            setState(() {
              isLoggedIn = isLogged;
              if (isLogged == false) {
                GlobalData.cartCountController.sink.add(
                  appStoragePref.getCartCount(),
                );
              }
            });
          },
        );
      },
    );
  }
}
