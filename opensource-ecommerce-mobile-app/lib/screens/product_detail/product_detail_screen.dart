import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bazar_marketplace_app/utils/bazar_theme.dart';
import 'package:bazar_marketplace_app/widgets/glassmorphic_components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviews;
  final List<String> images;
  final String description;
  final List<String> sizes;
  final List<Color> colors;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
    required this.productName,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.images,
    required this.description,
    required this.sizes,
    required this.colors,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentImageIndex = 0;
  int _selectedSizeIndex = 2;
  int _selectedColorIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;
  
  final CarouselController _carouselController = CarouselController();

  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Sarah Johnson',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'rating': 5,
      'date': '2 days ago',
      'comment': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'name': 'Mike Chen',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'rating': 4,
      'date': '1 week ago',
      'comment': 'Great product! Really comfortable and looks exactly like the pictures.',
    },
    {
      'name': 'Emily Davis',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'rating': 5,
      'date': '2 weeks ago',
      'comment': 'Excellent quality, fast shipping. Would definitely recommend!',
    },
  ];

  final List<Map<String, dynamic>> _recommendedProducts = [
    {
      'name': 'Running Shoes Pro',
      'price': 159.99,
      'image': 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa',
      'rating': 4.6,
    },
    {
      'name': 'Sport Sneakers',
      'price': 129.99,
      'image': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a',
      'rating': 4.8,
    },
    {
      'name': 'Casual Runners',
      'price': 99.99,
      'image': 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2',
      'rating': 4.5,
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
          CustomScrollView(
            slivers: [
              // App Bar with Image Carousel
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: _buildAppBarButton(
                  Icons.arrow_back,
                  () => Navigator.pop(context),
                ),
                actions: [
                  _buildAppBarButton(Icons.share, () {}),
                  const SizedBox(width: 8),
                  _buildAppBarButton(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      HapticFeedback.lightImpact();
                    },
                    color: _isFavorite ? BazarTheme.error : null,
                  ),
                  const SizedBox(width: 16),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Product Images Carousel
                      CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: 400,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                        ),
                        items: widget.images.map((image) {
                          return CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Container(
                              color: BazarTheme.lightGreen.withOpacity(0.3),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: BazarTheme.primaryGreen,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: BazarTheme.lightGreen.withOpacity(0.3),
                              child: Icon(
                                Icons.image_not_supported,
                                color: BazarTheme.textSecondary,
                                size: 50,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      // Image Indicators
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.images.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentImageIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentImageIndex == index
                                    ? BazarTheme.primaryGreen
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Product Details
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name and Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.productName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          ...List.generate(
                                            5,
                                            (index) => Icon(
                                              index < widget.rating.floor()
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              size: 18,
                                              color: Colors.amber,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${widget.rating}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            ' (${widget.reviews} reviews)',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: BazarTheme.textSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${widget.price.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: BazarTheme.primaryGreen,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    if (widget.oldPrice != null)
                                      Text(
                                        '\$${widget.oldPrice!.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: BazarTheme.textSecondary,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Color Selection
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Color',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: List.generate(
                                    widget.colors.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedColorIndex = index;
                                        });
                                        HapticFeedback.selectionClick();
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.only(right: 12),
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: widget.colors[index],
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _selectedColorIndex == index
                                                ? BazarTheme.primaryGreen
                                                : Colors.grey.shade300,
                                            width: _selectedColorIndex == index
                                                ? 3
                                                : 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Size Selection
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Size',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Size Guide',
                                        style: TextStyle(
                                          color: BazarTheme.primaryGreen,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: List.generate(
                                    widget.sizes.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedSizeIndex = index;
                                        });
                                        HapticFeedback.selectionClick();
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.only(right: 12),
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: _selectedSizeIndex == index
                                              ? BazarTheme.primaryGreen
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _selectedSizeIndex == index
                                                ? BazarTheme.primaryGreen
                                                : Colors.grey.shade300,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.sizes[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: _selectedSizeIndex == index
                                                      ? Colors.white
                                                      : BazarTheme.textPrimary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Quantity Selector
                            Row(
                              children: [
                                Text(
                                  'Quantity',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: BazarTheme.lightGreen.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (_quantity > 1) {
                                            setState(() {
                                              _quantity--;
                                            });
                                            HapticFeedback.selectionClick();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                          color: _quantity > 1
                                              ? BazarTheme.primaryGreen
                                              : BazarTheme.textSecondary,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          _quantity.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _quantity++;
                                          });
                                          HapticFeedback.selectionClick();
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: BazarTheme.primaryGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 24),
                            
                            // Customer Reviews
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customer Reviews',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                ...List.generate(
                                  _reviews.length > 2 ? 2 : _reviews.length,
                                  (index) => _buildReviewCard(_reviews[index]),
                                ),
                                if (_reviews.length > 2)
                                  Center(
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'View All Reviews',
                                        style: TextStyle(
                                          color: BazarTheme.primaryGreen,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 24),
                            
                            // Recommended Products
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recommended Products',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 220,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _recommendedProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = _recommendedProducts[index];
                                      return _buildRecommendedCard(product);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Bottom Action Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: BazarTheme.primaryGreen,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                      },
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: BazarTheme.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GlassmorphicButton(
                      text: 'Add to Cart',
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                      },
                      height: 56,
                      borderRadius: 16,
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

  Widget _buildAppBarButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color ?? BazarTheme.textPrimary,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BazarTheme.lightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(review['avatar']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < review['rating']
                                ? Icons.star
                                : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review['date'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: BazarTheme.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard(Map<String, dynamic> product) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: BazarTheme.lightGreen.withOpacity(0.3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: product['image'],
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: BazarTheme.primaryGreen,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product['name'],
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 14,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                product['rating'].toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                '\$${product['price']}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: BazarTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}