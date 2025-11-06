// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/utils/responsive_layout.dart';

/// Responsive stats card showing key metrics
class ResponsiveStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final String? trend;
  final bool isPositiveTrend;
  final VoidCallback? onTap;

  const ResponsiveStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trend,
    this.isPositiveTrend = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: context.responsivePadding,
          child: ResponsiveLayout(
            mobile: _buildMobileLayout(context),
            tablet: _buildDesktopLayout(context),
            desktop: _buildDesktopLayout(context),
            largeDesktop: _buildDesktopLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? Theme.of(context).colorScheme.primary)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ResponsiveText(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          mobileFontSize: 24,
          tabletFontSize: 28,
          desktopFontSize: 32,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
        if (trend != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                color: isPositiveTrend ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                trend!,
                style: TextStyle(
                  color: isPositiveTrend ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (iconColor ?? Theme.of(context).colorScheme.primary)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
              const SizedBox(height: 4),
              ResponsiveText(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                mobileFontSize: 24,
                tabletFontSize: 28,
                desktopFontSize: 32,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                ),
              ],
            ],
          ),
        ),
        if (trend != null) ...[
          Column(
            children: [
              Icon(
                isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                color: isPositiveTrend ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                trend!,
                style: TextStyle(
                  color: isPositiveTrend ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Product showcase card with image and details
class ResponsiveProductCard extends StatelessWidget {
  final String name;
  final String? description;
  final String price;
  final String? originalPrice;
  final String? imageUrl;
  final String? category;
  final double? rating;
  final int? reviewCount;
  final bool isOnSale;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddToCart;
  final bool isFavorite;

  const ResponsiveProductCard({
    super.key,
    required this.name,
    this.description,
    required this.price,
    this.originalPrice,
    this.imageUrl,
    this.category,
    this.rating,
    this.reviewCount,
    this.isOnSale = false,
    this.onTap,
    this.onFavorite,
    this.onAddToCart,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            Padding(
              padding: context.responsivePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryAndFavorite(context),
                  const SizedBox(height: 8),
                  _buildProductName(context),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    _buildDescription(context),
                  ],
                  const SizedBox(height: 8),
                  _buildRatingAndReviews(context),
                  const SizedBox(height: 12),
                  _buildPriceSection(context),
                  const SizedBox(height: 16),
                  _buildActionButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: context.responsiveValue(
            mobile: 200.0,
            tablet: 220.0,
            desktop: 240.0,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          ),
          child: imageUrl != null
              ? ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceVariant
                          .withOpacity(0.3),
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              : Icon(
                  Icons.image,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
        ),
        if (isOnSale) ...[
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'SALE',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        Positioned(
          top: 12,
          right: 12,
          child: IconButton(
            onPressed: onFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryAndFavorite(BuildContext context) {
    if (category == null) return const SizedBox.shrink();

    return Text(
      category!.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
    );
  }

  Widget _buildProductName(BuildContext context) {
    return ResponsiveText(
      name,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      mobileFontSize: 16,
      tabletFontSize: 18,
      desktopFontSize: 20,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      description!,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildRatingAndReviews(BuildContext context) {
    if (rating == null) return const SizedBox.shrink();

    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating!.floor() ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 16,
            );
          }),
        ),
        const SizedBox(width: 4),
        Text(
          rating!.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        if (reviewCount != null) ...[
          Text(
            ' (${reviewCount!})',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Row(
      children: [
        ResponsiveText(
          price,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
          mobileFontSize: 18,
          tabletFontSize: 20,
          desktopFontSize: 22,
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: 8),
          Text(
            originalPrice!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ResponsiveButton(
      onPressed: onAddToCart,
      isExpanded: true,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 20),
          SizedBox(width: 8),
          Text('Add to Cart'),
        ],
      ),
    );
  }
}

/// Timeline widget for showing progress or events
class ResponsiveTimeline extends StatelessWidget {
  final List<TimelineItem> items;
  final Color? lineColor;
  final double? lineWidth;

  const ResponsiveTimeline({
    super.key,
    required this.items,
    this.lineColor,
    this.lineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: item.isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.isCompleted ? Icons.check : item.icon,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  if (!isLast) ...[
                    Container(
                      width: lineWidth ?? 2,
                      height: 40,
                      color: lineColor ??
                          Theme.of(context)
                              .colorScheme
                              .outline
                              .withOpacity(0.3),
                    ),
                  ],
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      if (item.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.description!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                        ),
                      ],
                      if (item.timestamp != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          item.timestamp!,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.5),
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Timeline item data
class TimelineItem {
  final String title;
  final String? description;
  final String? timestamp;
  final IconData? icon;
  final bool isCompleted;

  TimelineItem({
    required this.title,
    this.description,
    this.timestamp,
    this.icon,
    this.isCompleted = false,
  });
}

/// User profile card with avatar and details
class ResponsiveUserProfileCard extends StatelessWidget {
  final String name;
  final String? email;
  final String? role;
  final String? avatarUrl;
  final List<ProfileAction>? actions;
  final VoidCallback? onTap;

  const ResponsiveUserProfileCard({
    super.key,
    required this.name,
    this.email,
    this.role,
    this.avatarUrl,
    this.actions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: context.responsivePadding,
          child: ResponsiveLayout(
            mobile: _buildMobileLayout(context),
            tablet: _buildDesktopLayout(context),
            desktop: _buildDesktopLayout(context),
            largeDesktop: _buildDesktopLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildAvatar(context),
        const SizedBox(height: 16),
        _buildUserInfo(context),
        if (actions != null) ...[
          const SizedBox(height: 16),
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(context),
        const SizedBox(width: 16),
        Expanded(child: _buildUserInfo(context)),
        if (actions != null) ...[
          const SizedBox(width: 16),
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final size = context.responsiveValue(
      mobile: 80.0,
      tablet: 100.0,
      desktop: 120.0,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: avatarUrl != null
            ? CachedNetworkImage(
                imageUrl: avatarUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            : Container(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: size * 0.5,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: context.isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          mobileFontSize: 20,
          tabletFontSize: 22,
          desktopFontSize: 24,
          textAlign: context.isMobile ? TextAlign.center : TextAlign.start,
        ),
        if (email != null) ...[
          const SizedBox(height: 4),
          Text(
            email!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
            textAlign: context.isMobile ? TextAlign.center : TextAlign.start,
          ),
        ],
        if (role != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    if (actions == null || actions!.isEmpty) return const SizedBox.shrink();

    return context.isMobile
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: actions!.map((action) {
              return IconButton(
                onPressed: action.onPressed,
                icon: Icon(action.icon),
                tooltip: action.label,
              );
            }).toList(),
          )
        : Column(
            children: actions!.map((action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton.icon(
                  onPressed: action.onPressed,
                  icon: Icon(action.icon, size: 16),
                  label: Text(action.label),
                ),
              );
            }).toList(),
          );
  }
}

/// Profile action data
class ProfileAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  ProfileAction({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
}

/// Notification banner for displaying alerts and messages
class ResponsiveNotificationBanner extends StatelessWidget {
  final String message;
  final NotificationType type;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool showAction;

  const ResponsiveNotificationBanner({
    super.key,
    required this.message,
    required this.type,
    this.onDismiss,
    this.onAction,
    this.actionLabel,
    this.showAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.responsiveMargin,
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getBorderColor(context),
          width: 1,
        ),
      ),
      child: Padding(
        padding: context.responsivePadding,
        child: Row(
          children: [
            Icon(
              _getIcon(),
              color: _getIconColor(context),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getTextColor(context),
                    ),
              ),
            ),
            if (showAction && actionLabel != null) ...[
              const SizedBox(width: 12),
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
            if (onDismiss != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close),
                iconSize: 20,
                color: _getTextColor(context).withOpacity(0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (type) {
      case NotificationType.success:
        return Colors.green.withOpacity(0.1);
      case NotificationType.warning:
        return Colors.orange.withOpacity(0.1);
      case NotificationType.error:
        return Colors.red.withOpacity(0.1);
      case NotificationType.info:
        return Theme.of(context).colorScheme.primary.withOpacity(0.1);
    }
  }

  Color _getBorderColor(BuildContext context) {
    switch (type) {
      case NotificationType.success:
        return Colors.green.withOpacity(0.3);
      case NotificationType.warning:
        return Colors.orange.withOpacity(0.3);
      case NotificationType.error:
        return Colors.red.withOpacity(0.3);
      case NotificationType.info:
        return Theme.of(context).colorScheme.primary.withOpacity(0.3);
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (type) {
      case NotificationType.success:
        return Colors.green.shade700;
      case NotificationType.warning:
        return Colors.orange.shade700;
      case NotificationType.error:
        return Colors.red.shade700;
      case NotificationType.info:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _getIconColor(BuildContext context) {
    return _getTextColor(context);
  }

  IconData _getIcon() {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.info:
        return Icons.info_outline;
    }
  }
}

/// Notification types
enum NotificationType { success, warning, error, info }

/// Empty state widget for when there's no data to display
class ResponsiveEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ResponsiveEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      centerContent: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: context.responsiveValue(
              mobile: 64.0,
              tablet: 80.0,
              desktop: 96.0,
            ),
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 24),
          ResponsiveText(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            mobileFontSize: 20,
            tabletFontSize: 22,
            desktopFontSize: 24,
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            ResponsiveButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
