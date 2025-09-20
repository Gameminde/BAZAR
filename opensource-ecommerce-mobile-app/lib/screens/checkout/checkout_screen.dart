import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bazar_marketplace_app/utils/bazar_theme.dart';
import 'package:bazar_marketplace_app/widgets/glassmorphic_components.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double subtotal;
  final double shipping;
  final double tax;

  const CheckoutScreen({
    Key? key,
    required this.cartItems,
    required this.subtotal,
    required this.shipping,
    required this.tax,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _promoController = TextEditingController();
  
  String _selectedAddress = '3d d 1000 - 20 drum\nCity New';
  String _selectedPayment = 'Visa ****1234';
  bool _isProcessing = false;
  
  late double _total;

  @override
  void initState() {
    super.initState();
    _total = widget.subtotal + widget.shipping + widget.tax;
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BazarTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Order Summary Section
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ...widget.cartItems.map((item) => _buildOrderItem(item)),
                  ],
                ),
              ),
              
              // Shipping Address Section
              _buildSection(
                title: 'Shipping Address',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassmorphicCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedAddress,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Show address selection
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: BazarTheme.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GlassmorphicButton(
                      text: 'Add New Address',
                      onPressed: () {
                        // Add new address
                      },
                      height: 48,
                      borderRadius: 12,
                      icon: Icons.add,
                    ),
                  ],
                ),
              ),
              
              // Payment Method Section
              _buildSection(
                title: 'Payment Method',
                content: Column(
                  children: [
                    GlassmorphicCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: BazarTheme.primaryGreen,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mastercard',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: BazarTheme.textSecondary,
                                      ),
                                ),
                                Text(
                                  _selectedPayment,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Change payment method
                            },
                            child: Text(
                              'Change',
                              style: TextStyle(
                                color: BazarTheme.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Promo Code Section
              _buildSection(
                title: 'Promo Code',
                content: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: TextField(
                          controller: _promoController,
                          decoration: InputDecoration(
                            hintText: 'Enter Promo Code',
                            hintStyle: TextStyle(
                              color: BazarTheme.textSecondary.withOpacity(0.6),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GlassmorphicButton(
                      text: 'Apply',
                      onPressed: () {
                        // Apply promo code
                        HapticFeedback.lightImpact();
                      },
                      width: 100,
                      height: 48,
                      borderRadius: 12,
                    ),
                  ],
                ),
              ),
              
              // Price Details Section
              _buildSection(
                title: '',
                content: GlassmorphicCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildPriceRow('Subtotal', widget.subtotal),
                      const SizedBox(height: 12),
                      _buildPriceRow('Shipping', widget.shipping),
                      const SizedBox(height: 12),
                      _buildPriceRow('Estimated Tax', widget.tax),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      _buildPriceRow('Total', _total, isTotal: true),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
        child: GlassmorphicButton(
          text: 'Proceed to Payment',
          onPressed: _processPayment,
          isLoading: _isProcessing,
          height: 56,
          borderRadius: 16,
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: BazarTheme.lightGreen.withOpacity(0.3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item['image'],
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item['size']} | Color: ${item['color']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: BazarTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item['price']}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: BazarTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Qty: ${item['quantity']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
          ],
          content,
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  )
              : Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: isTotal
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: BazarTheme.primaryGreen,
                    fontWeight: FontWeight.w700,
                  )
              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
        ),
      ],
    );
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });
    
    HapticFeedback.mediumImpact();
    
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(
            orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
            total: _total,
          ),
        ),
      );
    }
  }
}

class OrderConfirmationScreen extends StatefulWidget {
  final String orderNumber;
  final double total;

  const OrderConfirmationScreen({
    Key? key,
    required this.orderNumber,
    required this.total,
  }) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _fadeController;
  late Animation<double> _checkAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _checkController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BazarTheme.lightGreen,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Animation
                ScaleTransition(
                  scale: _checkAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: BazarTheme.primaryGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: BazarTheme.primaryGreen.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Success Message
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Order Confirmed!',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: BazarTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Thank for purchase!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: BazarTheme.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Order Details Card
                      GlassmorphicCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              context,
                              'Order Number',
                              widget.orderNumber,
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              context,
                              'Total Amount',
                              '\$${widget.total.toStringAsFixed(2)}',
                              isAmount: true,
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              context,
                              'Estimated Delivery',
                              '3-5 Business Days',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Action Buttons
                      GlassmorphicButton(
                        text: 'Track Order',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          // Navigate to order tracking
                        },
                        height: 56,
                        borderRadius: 28,
                      ),
                      const SizedBox(height: 16),
                      
                      // Share Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Share your new finds!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              _buildShareButton(Icons.share),
                              const SizedBox(width: 8),
                              _buildShareButton(Icons.camera_alt),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: TextButton(
          onPressed: () {
            // Navigate back to home
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Text(
            'Continue Shopping',
            style: TextStyle(
              color: BazarTheme.primaryGreen,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isAmount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: BazarTheme.textSecondary,
              ),
        ),
        Text(
          value,
          style: isAmount
              ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: BazarTheme.primaryGreen,
                    fontWeight: FontWeight.w700,
                  )
              : Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
        ),
      ],
    );
  }

  Widget _buildShareButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
        },
        icon: Icon(
          icon,
          color: BazarTheme.primaryGreen,
          size: 20,
        ),
      ),
    );
  }
}