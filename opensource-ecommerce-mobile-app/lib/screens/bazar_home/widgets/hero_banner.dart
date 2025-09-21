import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeroBannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final String buttonText;
  final List<Color> gradient;
  final VoidCallback onTap;

  const HeroBannerCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText,
    required this.gradient,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background image
              Positioned(
                right: -30,
                top: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.3,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    width: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.white.withOpacity(0.1)),
                    errorWidget: (context, url, error) =>
                        Container(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: gradient[0],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Person image overlay
              Positioned(
                right: 10,
                bottom: 0,
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: 160,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const SizedBox(),
                  errorWidget: (context, url, error) => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
