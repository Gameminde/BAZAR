import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bazar_marketplace_app/utils/bazar_theme.dart';
import 'package:bazar_marketplace_app/widgets/glassmorphic_container.dart';
import 'package:bazar_marketplace_app/screens/bazar_home/widgets/hero_banner.dart';
import 'package:bazar_marketplace_app/screens/bazar_home/widgets/search_bar_widget.dart';
import 'package:bazar_marketplace_app/screens/bazar_home/widgets/category_grid.dart';
import 'package:bazar_marketplace_app/screens/bazar_home/widgets/product_card.dart';
import 'package:bazar_marketplace_app/screens/bazar_home/widgets/bottom_nav_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BazarHomeScreen extends StatefulWidget {
  const BazarHomeScreen({Key? key}) : super(key: key);

  @override
  State<BazarHomeScreen> createState() => _BazarHomeScreenState();
}

class _BazarHomeScreenState extends State<BazarHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentBannerIndex = 0;
  int _selectedNavIndex = 0;
  final CarouselController _carouselController = CarouselController();

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Discover the\nPerfect Shopping Journey!',
      'subtitle': 'Find amazing products at unbeatable prices',
      'image': 'https://images.unsplash.com/photo-1483985988355-763728e1935b',
      'buttonText': 'Shop Now',
      'gradient': [BazarTheme.gradientStart, BazarTheme.gradientEnd],
    },
    {
      'title': 'Summer Sale\nUp to 70% Off',
      'subtitle': 'Limited time offers on selected items',
      'image': 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d',
      'buttonText': 'View Deals',
      'gradient': [Colors.purple.shade400, Colors.pink.shade300],
    },
    {
      'title': 'New Arrivals\nJust Landed',
      'subtitle': 'Be the first to get the latest trends',
      'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
      'buttonText': 'Explore',
      'gradient': [Colors.teal.shade400, Colors.blue.shade400],
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.checkroom, 'name': 'Fashion', 'color': Colors.purple},
    {'icon': Icons.home, 'name': 'Home', 'color': Colors.orange},
    {'icon': Icons.devices, 'name': 'Electronics', 'color': Colors.blue},
    {'icon': Icons.sports_basketball, 'name': 'Sports', 'color': Colors.green},
    {'icon': Icons.face, 'name': 'Beauty', 'color': Colors.pink},
    {'icon': Icons.headphones, 'name': 'Audio', 'color': Colors.indigo},
    {'icon': Icons.book, 'name': 'Books', 'color': Colors.brown},
    {'icon': Icons.toys, 'name': 'Toys', 'color': Colors.red},
  ];

  final List<Map<String, dynamic>> _popularProducts = [
    {
      'id': '1',
      'name': 'JMDA MaxLift 001',
      'price': 189.99,
      'oldPrice': 249.99,
      'rating': 4.7,
      'reviews': 234,
      'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
      'isNew': true,
      'discount': 24,
    },
    {
      'id': '2',
      'name': 'Wireless Headphones Pro',
      'price': 299.99,
      'oldPrice': 399.99,
      'rating': 4.9,
      'reviews': 512,
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
      'isNew': false,
      'discount': 25,
    },
    {
      'id': '3',
      'name': 'Smart Coffee Maker',
      'price': 149.99,
      'oldPrice': null,
      'rating': 4.5,
      'reviews': 128,
      'image': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
      'isNew': true,
      'discount': 0,
    },
    {
      'id': '4',
      'name': 'Premium Yoga Mat',
      'price': 59.99,
      'oldPrice': 79.99,
      'rating': 4.8,
      'reviews': 89,
      'image': 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f',
      'isNew': false,
      'discount': 25,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BazarTheme.backgroundLight,
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  BazarTheme.lightGreen.withOpacity(0.5),
                  BazarTheme.backgroundLight,
                ],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: _buildAppBar(),
                ),
                
                // Search Bar
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: const SearchBarWidget(),
                  ),
                ),
                
                // Hero Banner
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildHeroBanner(),
                  ),
                ),
                
                // Banner Indicators
                SliverToBoxAdapter(
                  child: _buildBannerIndicators(),
                ),
                
                // Categories Section
                SliverToBoxAdapter(
                  child: _buildCategoriesSection(),
                ),
                
                // Popular Products Section
                SliverToBoxAdapter(
                  child: _buildPopularSection(),
                ),
                
                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BazarBottomNavBar(
              selectedIndex: _selectedNavIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedNavIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: BazarTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Lagos, Nigeria',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              _buildAppBarIcon(Icons.notifications_outlined, () {}),
              const SizedBox(width: 12),
              _buildAppBarIcon(Icons.person_outline, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: BazarTheme.textPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider.builder(
        carouselController: _carouselController,
        itemCount: _banners.length,
        options: CarouselOptions(
          height: 200,
          viewportFraction: 0.9,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          onPageChanged: (index, reason) {
            setState(() {
              _currentBannerIndex = index;
            });
          },
        ),
        itemBuilder: (context, index, realIndex) {
          final banner = _banners[index];
          return HeroBannerCard(
            title: banner['title'],
            subtitle: banner['subtitle'],
            image: banner['image'],
            buttonText: banner['buttonText'],
            gradient: banner['gradient'],
            onTap: () {
              // Navigate to products
            },
          );
        },
      ),
    );
  }

  Widget _buildBannerIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _banners.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentBannerIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _currentBannerIndex == index
                ? BazarTheme.primaryGreen
                : BazarTheme.textSecondary.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See all',
                    style: TextStyle(
                      color: BazarTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategoryCard(
                  icon: category['icon'],
                  name: category['name'],
                  color: category['color'],
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See more',
                    style: TextStyle(
                      color: BazarTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _popularProducts.length,
              itemBuilder: (context, index) {
                final product = _popularProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ProductCard(
                    id: product['id'],
                    name: product['name'],
                    price: product['price'],
                    oldPrice: product['oldPrice'],
                    rating: product['rating'],
                    reviews: product['reviews'],
                    image: product['image'],
                    isNew: product['isNew'],
                    discount: product['discount'],
                    onTap: () {
                      // Navigate to product detail
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}