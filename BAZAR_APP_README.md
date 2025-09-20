# 🛍️ Bazar Marketplace App

A premium Flutter marketplace application with stunning glassmorphic design, inspired by modern e-commerce platforms like Temu and Amazon.

## ✨ Features

### 🎨 Beautiful UI/UX Design
- **Glassmorphic Design System**: Modern frosted glass effects throughout the app
- **Smooth Animations**: 60fps animations with elastic and spring curves
- **Responsive Layout**: Adapts perfectly to all screen sizes
- **Dark Mode Support**: Complete dark theme implementation
- **Custom Typography**: Google Fonts integration for beautiful text

### 📱 Core Screens Implemented

#### 1. **Home Screen** 
- Hero banner carousel with gradient overlays
- Animated search bar with voice search
- Category grid with colorful icons
- Popular products carousel
- Custom bottom navigation with badges
- Location-based header

#### 2. **Product Detail Screen**
- Image carousel with indicators
- Size and color selectors with haptic feedback
- Animated quantity selector
- Customer reviews section
- Recommended products carousel
- Floating action buttons for cart and favorites

#### 3. **Checkout Screen**
- Order summary with product cards
- Shipping address management
- Payment method selection
- Promo code application
- Price breakdown with taxes
- Glassmorphic payment button

#### 4. **Order Confirmation Screen**
- Success animation with elastic curves
- Order details card
- Social sharing options
- Track order functionality
- Continue shopping navigation

### 🎯 Key Components

#### Glassmorphic Components
- `GlassmorphicContainer`: Base container with blur effects
- `GlassmorphicCard`: Interactive cards with glass effects
- `GlassmorphicButton`: Animated buttons with loading states

#### Custom Widgets
- `HeroBannerCard`: Gradient banner with overlay effects
- `SearchBarWidget`: Animated search with voice input
- `CategoryCard`: Interactive category tiles
- `ProductCard`: Product cards with favorites
- `BazarBottomNavBar`: Custom navigation with badges

### 🎨 Design System

#### Color Palette
```dart
Primary Green: #4A7C59
Secondary Green: #5B8A67
Accent Green: #2E7D32
Light Green: #E8F5E8
Gradient Start: #E85A4F
Gradient End: #F4A261
```

#### Typography
- **Headlines**: Poppins (700, 600)
- **Body Text**: Inter (400, 500)
- **Labels**: Inter (500, 600)

### 🚀 Getting Started

#### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

#### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/bazar-marketplace.git
cd bazar-marketplace
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### 📦 Dependencies

Key packages used:
- `google_fonts`: Typography system
- `cached_network_image`: Optimized image loading
- `carousel_slider`: Image carousels
- `flutter_bloc`: State management
- `lottie`: Animations
- `glassmorphism`: Glass effects

### 🏗️ Project Structure

```
lib/
├── screens/
│   ├── bazar_home/
│   │   ├── bazar_home_screen.dart
│   │   └── widgets/
│   │       ├── hero_banner.dart
│   │       ├── search_bar_widget.dart
│   │       ├── category_grid.dart
│   │       ├── product_card.dart
│   │       └── bottom_nav_bar.dart
│   ├── product_detail/
│   │   └── product_detail_screen.dart
│   └── checkout/
│       └── checkout_screen.dart
├── utils/
│   └── bazar_theme.dart
└── widgets/
    └── glassmorphic_container.dart
```

### 🎯 Demo Navigation

The app includes a demo mode with sample data to showcase all features:

```dart
// Navigate to Product Detail
BazarNavigator.goToProductDetail(context);

// Navigate to Checkout
BazarNavigator.goToCheckout(context);

// Navigate to Order Confirmation
BazarNavigator.goToOrderConfirmation(context, orderNumber, total);
```

### 🌟 Features Roadmap

- [ ] User authentication system
- [ ] Real-time chat support
- [ ] AR product preview
- [ ] Multi-language support (Arabic, French, English)
- [ ] Payment gateway integration
- [ ] Push notifications
- [ ] Order tracking
- [ ] Wishlist management
- [ ] Product reviews and ratings
- [ ] Social media integration

### 🎨 Design Inspiration

The app design is inspired by:
- Modern e-commerce platforms (Temu, Amazon, Etsy)
- Glassmorphism design trend
- Material Design 3 guidelines
- iOS Human Interface Guidelines

### 📸 Screenshots

The app features:
- Clean and modern interface
- Smooth transitions between screens
- Interactive elements with haptic feedback
- Beautiful gradient overlays
- Professional product presentations

### 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### 📄 License

This project is licensed under the MIT License.

### 👨‍💻 Developer

Built with ❤️ using Flutter and modern UI/UX principles.

---

**Note**: This is a demonstration app showcasing modern Flutter UI/UX capabilities. All product data and images are for demonstration purposes only.