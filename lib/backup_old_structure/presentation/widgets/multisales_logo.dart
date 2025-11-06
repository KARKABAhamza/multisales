// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// A reusable MultiSales logo widget that can be used throughout the app
class MultiSalesLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool showShadow;
  final BoxFit fit;
  final bool showText;
  final Color? color;

  const MultiSalesLogo({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.showShadow = true,
    this.fit = BoxFit.contain,
    this.showText = true,
    this.color,
  });

  /// Factory constructor for a large logo (suitable for splash screens, headers)
  const MultiSalesLogo.large({
    super.key,
    this.showShadow = true,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.showText = true,
    this.color,
  })  : width = 200,
        height = 120;

  /// Factory constructor for a medium logo (suitable for app bars, cards)
  const MultiSalesLogo.medium({
    super.key,
    this.showShadow = true,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.showText = true,
    this.color,
  })  : width = 120,
        height = 72;

  /// Factory constructor for a small logo (suitable for list items, avatars)
  const MultiSalesLogo.small({
    super.key,
    this.showShadow = false,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.showText = false,
    this.color,
  })  : width = 48,
        height = 28;

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Theme.of(context).primaryColor;
    final logoSize = width ?? 120;

    Widget logo = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Icon/Symbol
        Container(
          width: logoSize,
          height: height ?? (logoSize * 0.8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius:
                borderRadius ?? BorderRadius.circular(logoSize * 0.15),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: ClipRRect(
                  borderRadius:
                      borderRadius ?? BorderRadius.circular(logoSize * 0.15),
                  child: CustomPaint(
                    painter: LogoPatternPainter(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              // Main logo content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MS letters
                    Text(
                      'MS',
                      style: TextStyle(
                        fontSize: logoSize * 0.25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    // Subtitle
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: logoSize * 0.08,
                        vertical: logoSize * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(logoSize * 0.04),
                      ),
                      child: Text(
                        'SALES',
                        style: TextStyle(
                          fontSize: logoSize * 0.08,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (showText) ...[
          SizedBox(height: logoSize * 0.1),
          Text(
            'MultiSales',
            style: TextStyle(
              fontSize: logoSize * 0.15,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: logoSize * 0.03),
          Text(
            'Empowering Your Sales Journey',
            style: TextStyle(
              fontSize: logoSize * 0.07,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );

    return logo;
  }
}

class LogoPatternPainter extends CustomPainter {
  final Color color;

  LogoPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw geometric pattern
    const double spacing = 15;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Draw small circles
        canvas.drawCircle(
          Offset(x, y),
          2,
          paint,
        );

        // Draw connecting lines
        if (x + spacing < size.width) {
          canvas.drawLine(
            Offset(x + 2, y),
            Offset(x + spacing - 2, y),
            paint,
          );
        }

        if (y + spacing < size.height) {
          canvas.drawLine(
            Offset(x, y + 2),
            Offset(x, y + spacing - 2),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CompactMultiSalesLogo extends StatelessWidget {
  final double height;
  final Color? color;

  const CompactMultiSalesLogo({
    super.key,
    this.height = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Theme.of(context).primaryColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(height * 0.2),
          ),
          child: Center(
            child: Text(
              'MS',
              style: TextStyle(
                fontSize: height * 0.4,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        SizedBox(width: height * 0.3),
        Text(
          'MultiSales',
          style: TextStyle(
            fontSize: height * 0.5,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
