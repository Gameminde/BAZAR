<p align="center">
    <img src="assets/images/bazar_logo.svg" alt="BAZAR Marketplace" width="200">
</p>

<p align="center">
    <a href="https://bazar.marketplace.com"><img src="https://img.shields.io/badge/Website-bazar.marketplace.com-blue" alt="Website"></a>
    <a href="https://github.com/bazar-marketplace/bazar-mobile-app"><img src="https://img.shields.io/github/stars/bazar-marketplace/bazar-mobile-app?style=social" alt="GitHub Stars"></a>
    <a href="https://twitter.com/bazarmarketplace"><img src="https://img.shields.io/twitter/follow/bazarmarketplace?style=social" alt="Twitter Follow"></a>
</p>

# BAZAR Marketplace Mobile App

**BAZAR Marketplace** revolutionizes mobile commerce with its modern, open-source Flutter eCommerce application. This cutting-edge mobile marketplace app provides seamless product browsing, secure transactions, and an intuitive shopping experience for both customers and merchants.

## 🚀 Features

### 🏪 **Modern Marketplace Experience**
- **Interactive Home Page**: Dynamic product showcases with trending items
- **Advanced Search**: AI-powered product discovery with filters and categories
- **Smart Recommendations**: Personalized product suggestions based on user behavior
- **Multi-vendor Support**: Seamless integration with multiple sellers

### 🛒 **Shopping & Commerce**
- **Shopping Cart**: Add, remove, and manage items with real-time updates
- **Wishlist**: Save favorite products for later purchase
- **Product Comparison**: Side-by-side product feature comparison
- **Reviews & Ratings**: Customer feedback system with photo reviews

### 💳 **Secure Payments**
- **Multiple Payment Methods**: Credit cards, PayPal, digital wallets
- **Secure Checkout**: PCI-compliant payment processing
- **Order Tracking**: Real-time order status updates
- **Invoice Management**: Digital receipts and order history

### 👤 **User Experience**
- **Multi-language Support**: Arabic (RTL), English, French, Spanish, and more
- **Dark/Light Themes**: Customizable UI themes
- **Push Notifications**: Order updates and promotional alerts
- **Offline Support**: Browse cached products without internet

### 🏢 **Merchant Features**
- **Vendor Dashboard**: Comprehensive sales analytics and inventory management
- **Product Management**: Easy product upload with bulk import
- **Order Fulfillment**: Streamlined order processing workflow
- **Commission Tracking**: Transparent fee structure and earnings

## 📱 **Platform Support**

- **Android**: Minimum SDK 21 (Android 5.0)
- **iOS**: iOS 12.0 and above
- **Web**: Progressive Web App (PWA) support
- **Desktop**: Windows, macOS, Linux (Flutter Desktop)

## 🛠 **Technology Stack**

- **Framework**: Flutter 3.19+
- **State Management**: BLoC Pattern
- **Backend**: REST API + GraphQL
- **Database**: Hive (Local) + Remote API
- **Authentication**: JWT with refresh tokens
- **Payments**: Stripe, PayPal integration
- **Push Notifications**: Firebase Cloud Messaging
- **Analytics**: Firebase Analytics

## 🚀 **Quick Start**

### Prerequisites
- Flutter SDK 3.19.0 or higher
- Dart SDK 3.3.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/bazar-marketplace/bazar-mobile-app.git
   cd bazar-mobile-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure the app**
   - Update `lib/utils/server_configuration.dart` with your API endpoints
   - Configure Firebase for push notifications
   - Set up payment gateway credentials

4. **Run the app**
   ```bash
   flutter run
   ```

## ⚙️ **Configuration**

### API Configuration
Update the following files with your backend configuration:

```dart
// lib/utils/server_configuration.dart
const String baseDomain = "https://your-api-domain.com";
const String baseUrl = "$baseDomain/api";
```

### Firebase Setup
1. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
2. Configure Firebase Cloud Messaging for push notifications
3. Enable Firebase Analytics for user behavior tracking

### Payment Integration
Configure payment gateways in:
- Stripe: Add your publishable key
- PayPal: Configure client ID and secret
- Other gateways: Follow respective documentation

## 🎨 **Customization**

### Branding
- **App Icon**: Replace icons in `android/app/src/main/res/` and `ios/Runner/Assets.xcassets/`
- **Splash Screen**: Customize in `lib/screens/splash_screen/`
- **Colors**: Update `lib/utils/bazar_theme.dart`
- **Logo**: Replace `assets/images/bazar_logo.svg`

### Themes
The app supports comprehensive theming through `BazarTheme`:

```dart
// Light theme
ThemeData lightTheme = BazarTheme.lightTheme;

// Dark theme  
ThemeData darkTheme = BazarTheme.darkTheme;
```

## 📦 **Build & Deploy**

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 **Support**

- **Documentation**: [docs.bazar.marketplace.com](https://docs.bazar.marketplace.com)
- **Community**: [Discord Server](https://discord.gg/bazarmarketplace)
- **Issues**: [GitHub Issues](https://github.com/bazar-marketplace/bazar-mobile-app/issues)
- **Email**: support@bazar.marketplace.com

## 🌟 **Acknowledgments**

- Flutter team for the amazing framework
- Open source community for various packages
- Contributors and beta testers

## 📊 **Project Status**

![GitHub last commit](https://img.shields.io/github/last-commit/bazar-marketplace/bazar-mobile-app)
![GitHub issues](https://img.shields.io/github/issues/bazar-marketplace/bazar-mobile-app)
![GitHub pull requests](https://img.shields.io/github/issues-pr/bazar-marketplace/bazar-mobile-app)
![GitHub license](https://img.shields.io/github/license/bazar-marketplace/bazar-mobile-app)

---

<p align="center">
    Made with ❤️ by the BAZAR Marketplace Team
</p>

<p align="center">
    <a href="https://bazar.marketplace.com">Website</a> •
    <a href="https://docs.bazar.marketplace.com">Documentation</a> •
    <a href="https://github.com/bazar-marketplace/bazar-mobile-app/issues">Report Bug</a> •
    <a href="https://github.com/bazar-marketplace/bazar-mobile-app/issues">Request Feature</a>
</p>