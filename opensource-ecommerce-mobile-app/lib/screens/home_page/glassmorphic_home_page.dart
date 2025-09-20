/*
 * Glassmorphic HomePage - BAZAR 2025
 * Transformation spectaculaire avec glassmorphism
 */

import 'package:flutter/material.dart';
import 'package:bazar_marketplace_app/screens/home_page/utils/index.dart';
import 'package:bazar_marketplace_app/screens/home_page/data_model/theme_customization.dart';
import 'package:bazar_marketplace_app/screens/home_page/widget/service_content.dart';
import 'package:bazar_marketplace_app/screens/home_page/widget/static_content_widget.dart';
import 'package:bazar_marketplace_app/screens/home_page/widget/footer_links.dart';
import 'package:bazar_marketplace_app/widgets/glassmorphism/glassmorphic_components.dart';
// import 'package:bazar_marketplace_app/widgets/floating_particles_widget_basic.dart'; // Supprimé, maintenant dans glassmorphic_components.dart
// import 'package:bazar_marketplace_app/utils/bazar_glassmorphism_theme.dart'; // Fichier supprimé
import 'dart:developer';

class GlassmorphicHomePage extends StatefulWidget {
  final ThemeCustomDataModel? customHomeData;
  final bool isLoading;
  final bool isLogin;
  final GetDrawerCategoriesData? getCategoriesData;
  final HomePageBloc? homePageBloc;
  final bool callPreCache;

  const GlassmorphicHomePage({
    Key? key,
    this.customHomeData,
    this.isLoading = false,
    this.isLogin = false,
    this.getCategoriesData,
    this.homePageBloc,
    this.callPreCache = true,
  }) : super(key: key);

  @override
  _GlassmorphicHomePageState createState() => _GlassmorphicHomePageState();
}

class _GlassmorphicHomePageState extends State<GlassmorphicHomePage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _particlesController;
  late Animation<double> _heroAnimation;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Animation du hero section
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..forward();

    _heroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );

    // Animation des particules
    _particlesController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _heroController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background animé avec particules
        _buildAnimatedBackground(),

        // Contenu principal avec glassmorphism
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildGlassmorphicAppBar(),
          body: _buildGlassmorphicBody(),
        ),
      ],
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Gradient mesh background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF4A7C59).withValues(alpha: 0.3),
                const Color(0xFF5B8A67).withValues(alpha: 0.2),
                const Color(0xFFF4A261).withValues(alpha: 0.1),
              ],
            ),
          ),
        ),

        // Particules flottantes simplifiées
        const FloatingParticlesWidget(),
      ],
    );
  }

  PreferredSizeWidget _buildGlassmorphicAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('BAZAR', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, searchScreen),
        ),
        IconButton(
          icon: const Icon(Icons.compare_arrows, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, compareScreen),
        ),
        StreamBuilder(
          stream: GlobalData.cartCountController.stream,
          builder: (BuildContext context, snapshot) {
            int count = snapshot.data ?? 0;
            return Stack(
              children: [
                GlassmorphicCard(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pushNamed(context, cartScreen),
                  ),
                ),
                if (count > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildGlassmorphicBody() {
    return RefreshIndicator(
      color: const Color(0xFFF4A261),
      onRefresh: () async {
        HomePageBloc homePageBloc = context.read<HomePageBloc>();
        homePageBloc.add(FetchHomeCustomData());
        return Future.delayed(const Duration(seconds: 4), () {});
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section glassmorphism
                _buildHeroSection(),

                // Contenu dynamique avec glassmorphism
                ..._getGlassmorphicHomepageView(
                  widget.customHomeData,
                  MediaQuery.of(context).size,
                ),

                // Footer glassmorphism
                _buildFooterSection(),
              ],
            ),
          ),

          // Loader glassmorphism
          if (widget.isLoading)
            const Align(
              alignment: Alignment.center,
              child: GlassmorphicCard(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFFF4A261),
                    ),
                  ),
                ),
              ),
            ),
        ],
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
              height: 220,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo animé
                  AnimatedBuilder(
                    animation: _heroController,
                    builder: (context, child) => Transform.scale(
                      scale: 0.8 + (_heroAnimation.value * 0.2),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A7C59), Color(0xFF5B8A67)],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Text(
                          '🛍️ BAZAR',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Slogan animé
                  FadeTransition(
                    opacity: _heroAnimation,
                    child: Text(
                      'Votre marketplace algérienne premium',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description animée
                  FadeTransition(
                    opacity: _heroAnimation,
                    child: Text(
                      'Découvrez des milliers de produits\nde qualité avec une expérience\nexceptionnelle',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Boutons d'action animés
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Explorer',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.category, color: Colors.white),
                        label: const Text(
                          'Catégories',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicCategories(Size size) {
    return (widget.getCategoriesData?.data ?? []).isNotEmpty
        ? Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catégories Populaires',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.getCategoriesData?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      HomeCategories? item =
                          widget.getCategoriesData?.data?[index];

                      if (item?.id == "1") return const SizedBox();

                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 16),
                        child: GlassmorphicCard(
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            onTap: () {
                              if ((item?.children ?? []).isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  drawerSubCategoryScreen,
                                  arguments: CategoriesArguments(
                                    categorySlug: item?.slug,
                                    title: item?.name,
                                    id: item?.id.toString(),
                                    image: item?.bannerUrl ?? "",
                                    parentId: "1",
                                  ),
                                );
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  categoryScreen,
                                  arguments: CategoriesArguments(
                                    categorySlug: item?.slug,
                                    title: item?.name,
                                    id: item?.id,
                                    image: item?.bannerUrl,
                                  ),
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.category,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item?.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  List<Widget> _getGlassmorphicHomepageView(
    ThemeCustomDataModel? customHomeData,
    Size size,
  ) {
    List<Widget> homeWidgets = [];
    int index = 0;

    customHomeData?.themeCustomization?.forEach((element) {
      switch (element.type) {
        case 'footer_links':
          homeWidgets.add(
            Column(
              children: [
                RecentView(isLogin: widget.isLogin),
                const SizedBox(height: 20),
                if (GlobalData.allProducts?.isNotEmpty == true)
                  buildReachBottomView(context, _scrollController),
                const SizedBox(height: 20),
                GlassmorphicCard(
                  padding: const EdgeInsets.all(20),
                  child: FooterColumnsScreen(
                    element.translations?.firstOrNull?.options,
                    title: element.name,
                    homePageBloc: widget.homePageBloc,
                  ),
                ),
              ],
            ),
          );
          break;

        case 'services_content':
          homeWidgets.add(
            GlassmorphicCard(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              child: ServiceGridScreen(
                element.translations?.firstOrNull?.options?.services,
              ),
            ),
          );
          break;

        case "image_carousel":
          homeWidgets.add(
            GlassmorphicCard(
              margin: const EdgeInsets.all(20),
              child: CarousalSlider(sliders: element),
            ),
          );
          break;

        case "static_content":
          log(
            "Static Content: ${element.translations?.firstOrNull?.options?.css}",
          );
          log(
            "Static html: ${element.translations?.firstOrNull?.options?.html}",
          );
          log("links: ${element.translations?.firstOrNull?.options?.links}");
          homeWidgets.add(
            GlassmorphicCard(
              margin: const EdgeInsets.all(20),
              key: ValueKey('static_${element.id}'),
              child: StaticContentWidget(
                html: element.translations?.firstOrNull?.options?.html ?? "",
                css: element.translations?.firstOrNull?.options?.css ?? "",
                links: element.translations?.firstOrNull?.options?.links,
              ),
            ),
          );
          break;

        case "category_carousel":
          homeWidgets.add(_buildGlassmorphicCategories(size));
          break;

        case "product_carousel":
          final id = element.id?.toString() ?? '';
          final productsModel = GlobalData.allProducts[id];
          if (productsModel?.data?.isNotEmpty ?? false) {
            homeWidgets.add(
              GlassmorphicCard(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width / 1.5) + 220,
                  child: NewProductView(
                    title:
                        element.translations?.firstOrNull?.options?.title ?? "",
                    isLogin: widget.isLogin,
                    model: productsModel?.data,
                    callPreCache: widget.callPreCache,
                    filters: element.translations?.firstOrNull?.options?.filters
                        ?.map((f) => f.toJson())
                        .toList(),
                  ),
                ),
              ),
            );
          }
          break;
      }
      index++;
    });

    return homeWidgets;
  }

  Widget _buildFooterSection() {
    return GlassmorphicCard(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GlassmorphicCard(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(Icons.info, color: Colors.white, size: 32),
                      const SizedBox(height: 8),
                      Text('À propos', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              GlassmorphicCard(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(Icons.contact_mail, color: Colors.white, size: 32),
                      const SizedBox(height: 8),
                      Text('Contact', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              GlassmorphicCard(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Icon(Icons.help, color: Colors.white, size: 32),
                      const SizedBox(height: 8),
                      Text('Support', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '© 2025 BAZAR Marketplace - Votre partenaire shopping',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildReachBottomView(
    BuildContext context,
    ScrollController scrollController,
  ) {
    return GlassmorphicCard(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      child: FloatingActionButton(
        onPressed: () {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
