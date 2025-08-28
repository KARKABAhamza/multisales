import 'package:flutter/material.dart';

/// Comprehensive responsive layout helper with advanced breakpoints and utilities
class ResponsiveLayout extends StatelessWidget {
  /// Mobile layout (phones)
  final Widget? mobile;

  /// Tablet layout (tablets in portrait)
  final Widget? tablet;

  /// Desktop layout (tablets in landscape, small laptops, desktops)
  final Widget? desktop;

  /// Large desktop layout (large monitors)
  final Widget? largeDesktop;

  /// Universal widget that will be used if specific layout is not provided
  final Widget? universal;

  const ResponsiveLayout({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    this.universal,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = DeviceType.fromWidth(constraints.maxWidth);

        switch (deviceType) {
          case DeviceType.mobile:
            return mobile ?? universal ?? const SizedBox.shrink();
          case DeviceType.tablet:
            return tablet ?? mobile ?? universal ?? const SizedBox.shrink();
          case DeviceType.desktop:
            return desktop ??
                tablet ??
                mobile ??
                universal ??
                const SizedBox.shrink();
          case DeviceType.largeDesktop:
            return largeDesktop ??
                desktop ??
                tablet ??
                mobile ??
                universal ??
                const SizedBox.shrink();
        }
      },
    );
  }
}

/// Device type enumeration for responsive breakpoints
enum DeviceType {
  mobile, // < 768px
  tablet, // 768px - 1024px
  desktop, // 1024px - 1440px
  largeDesktop; // > 1440px

  factory DeviceType.fromWidth(double width) {
    if (width < ResponsiveBreakpoints.tablet) {
      return DeviceType.mobile;
    } else if (width < ResponsiveBreakpoints.desktop) {
      return DeviceType.tablet;
    } else if (width < ResponsiveBreakpoints.largeDesktop) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }
}

/// Responsive breakpoints constants
class ResponsiveBreakpoints {
  static const double mobile = 0;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;

  // Additional breakpoints for fine-tuning
  static const double smallMobile = 360;
  static const double largeMobile = 480;
  static const double smallTablet = 600;
  static const double largeTablet = 900;
  static const double smallDesktop = 1200;
}

/// Responsive utilities for sizing, spacing, and layout decisions
class ResponsiveUtils {
  /// Get device type from context
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return DeviceType.fromWidth(width);
  }

  /// Check if current device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  /// Check if current device is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.largeDesktop;
  }

  /// Check if device is mobile or tablet (touch devices)
  static bool isTouchDevice(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;
  }

  /// Get responsive value based on device type
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
      largeDesktop: const EdgeInsets.all(48),
    );
  }

  /// Get responsive margin
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: const EdgeInsets.all(8),
      tablet: const EdgeInsets.all(12),
      desktop: const EdgeInsets.all(16),
      largeDesktop: const EdgeInsets.all(24),
    );
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    return getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }

  /// Get responsive width percentage
  static double getResponsiveWidth(
    BuildContext context, {
    double mobile = 1.0,
    double? tablet,
    double? desktop,
    double? largeDesktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final percentage = getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
    return screenWidth * percentage;
  }

  /// Get responsive grid columns
  static int getResponsiveGridColumns(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
      largeDesktop: 4,
    );
  }

  /// Get responsive aspect ratio
  static double getResponsiveAspectRatio(BuildContext context) {
    return getResponsiveValue(
      context,
      mobile: 1.2,
      tablet: 1.4,
      desktop: 1.6,
      largeDesktop: 1.8,
    );
  }
}

/// Responsive container that adapts its max width based on device type
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? maxWidth;
  final bool centerContent;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.maxWidth,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);

    double containerMaxWidth;
    switch (deviceType) {
      case DeviceType.mobile:
        containerMaxWidth = double.infinity;
        break;
      case DeviceType.tablet:
        containerMaxWidth = 768;
        break;
      case DeviceType.desktop:
        containerMaxWidth = 1024;
        break;
      case DeviceType.largeDesktop:
        containerMaxWidth = 1200;
        break;
    }

    Widget content = Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? containerMaxWidth,
      ),
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      margin: margin,
      decoration: backgroundColor != null
          ? BoxDecoration(color: backgroundColor)
          : null,
      child: child,
    );

    if (centerContent && deviceType != DeviceType.mobile) {
      content = Center(child: content);
    }

    return content;
  }
}

/// Responsive grid that automatically adjusts columns based on device type
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final double? runSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final int? largeDesktopColumns;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing,
    this.runSpacing,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.largeDesktopColumns,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
      largeDesktop: largeDesktopColumns ?? 4,
    );

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing ?? 16,
      mainAxisSpacing: runSpacing ?? 16,
      childAspectRatio: childAspectRatio ?? 1.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// Responsive row that can wrap to column on smaller screens
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool wrapOnMobile;
  final double spacing;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.wrapOnMobile = true,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (wrapOnMobile && ResponsiveUtils.isMobile(context)) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .expand((child) => [child, SizedBox(height: spacing)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children
          .expand((child) => [child, SizedBox(width: spacing)])
          .take(children.length * 2 - 1)
          .toList(),
    );
  }
}

/// Responsive text widget that adjusts font size based on device type
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;
  final double? largeDesktopFontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
    this.largeDesktopFontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final baseFontSize = style?.fontSize ?? 14.0;

    final fontSize = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: mobileFontSize ?? baseFontSize,
      tablet: tabletFontSize ?? baseFontSize * 1.1,
      desktop: desktopFontSize ?? baseFontSize * 1.2,
      largeDesktop: largeDesktopFontSize ?? baseFontSize * 1.3,
    );

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Responsive app bar that adjusts height and padding based on device type
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;

  const ResponsiveAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);

    final appBarHeight = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 56.0,
      tablet: 64.0,
      desktop: 72.0,
      largeDesktop: 80.0,
    );

    return AppBar(
      title: title,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle || deviceType == DeviceType.mobile,
      toolbarHeight: appBarHeight,
    );
  }

  @override
  Size get preferredSize {
    // Use a default height since we can't access context here
    return const Size.fromHeight(56.0);
  }
}

/// Responsive card with adaptive padding and elevation
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final EdgeInsets responsivePadding = padding ??
        ResponsiveUtils.getResponsiveValue(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(20),
          desktop: const EdgeInsets.all(24),
          largeDesktop: const EdgeInsets.all(28),
        );

    final responsiveElevation = elevation ??
        ResponsiveUtils.getResponsiveValue(
          context,
          mobile: 2.0,
          tablet: 4.0,
          desktop: 6.0,
          largeDesktop: 8.0,
        );

    return Card(
      margin: margin,
      color: color,
      elevation: responsiveElevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Padding(
        padding: responsivePadding,
        child: child,
      ),
    );
  }
}

/// Responsive form field with adaptive sizing
class ResponsiveFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;

  const ResponsiveFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final fieldHeight = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 48.0,
      tablet: 52.0,
      desktop: 56.0,
      largeDesktop: 60.0,
    );

    return SizedBox(
      height: maxLines == 1 ? fieldHeight : null,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(
            context,
            mobile: 16,
            tablet: 17,
            desktop: 18,
            largeDesktop: 19,
          ),
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: ResponsiveUtils.getResponsiveValue(
                context,
                mobile:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                tablet:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                desktop:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                largeDesktop:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              ) ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

/// Responsive button with adaptive sizing
class ResponsiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isExpanded;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final ButtonStyle? style;

  const ResponsiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isExpanded = false,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 48.0,
      tablet: 52.0,
      desktop: 56.0,
      largeDesktop: 60.0,
    );

    final buttonPadding = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      tablet: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      desktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      largeDesktop: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
    );

    Widget button = ElevatedButton(
      onPressed: onPressed,
      style: (style ?? ElevatedButton.styleFrom()).copyWith(
        backgroundColor: backgroundColor != null
            ? WidgetStateProperty.all(backgroundColor)
            : null,
        foregroundColor: foregroundColor != null
            ? WidgetStateProperty.all(foregroundColor)
            : null,
        padding: WidgetStateProperty.all(buttonPadding),
        minimumSize: WidgetStateProperty.all(Size(0, buttonHeight)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: child,
    );

    if (isExpanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

/// Extension on BuildContext for easier responsive access
extension ResponsiveContext on BuildContext {
  /// Get device type
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);

  /// Check if mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Check if tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Check if desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  /// Check if large desktop
  bool get isLargeDesktop => ResponsiveUtils.isLargeDesktop(this);

  /// Check if touch device
  bool get isTouchDevice => ResponsiveUtils.isTouchDevice(this);

  /// Get responsive value
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) =>
      ResponsiveUtils.getResponsiveValue(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        largeDesktop: largeDesktop,
      );

  /// Get responsive padding
  EdgeInsets get responsivePadding =>
      ResponsiveUtils.getResponsivePadding(this);

  /// Get responsive margin
  EdgeInsets get responsiveMargin => ResponsiveUtils.getResponsiveMargin(this);
}
