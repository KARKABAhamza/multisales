// ResponsiveLayout utility and context extension for responsiveValue
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final Widget? largeDesktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    this.largeDesktop,
  });

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024 && MediaQuery.of(context).size.width < 1440;
  static bool isLargeDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1440;

  @override
  Widget build(BuildContext context) {
    if (isLargeDesktop(context) && largeDesktop != null) {
      return largeDesktop!;
    } else if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return mobile;
    }
  }
}

extension ResponsiveContext on BuildContext {
  T responsiveValue<T>({required T mobile, T? tablet, T? desktop, T? largeDesktop}) {
    final width = MediaQuery.of(this).size.width;
    if (largeDesktop != null && width >= 1440) return largeDesktop;
    if (desktop != null && width >= 1024) return desktop;
    if (tablet != null && width >= 600) return tablet;
    return mobile;
  }
}
