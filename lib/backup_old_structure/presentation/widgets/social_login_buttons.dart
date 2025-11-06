import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLoginButtons extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final void Function()? onGoogle;
  final void Function()? onFacebook;
  final void Function()? onApple;
  final String? googleLabel;
  final String? facebookLabel;
  final String? appleLabel;
  final IconData? googleIcon;
  final IconData? facebookIcon;
  final IconData? appleIcon;
  final Color? googleColor;
  final Color? facebookColor;
  final Color? appleColor;
  final bool googleLoading;
  final bool facebookLoading;
  final bool appleLoading;
  final void Function()? onTermsTap;
  final void Function()? onPrivacyTap;
  const SocialLoginButtons({
    super.key,
    this.isLoading = false,
    this.errorMessage,
    this.onGoogle,
    this.onFacebook,
    this.onApple,
    this.googleLabel,
    this.facebookLabel,
    this.appleLabel,
    this.googleIcon,
    this.facebookIcon,
    this.appleIcon,
    this.googleColor,
    this.facebookColor,
    this.appleColor,
    this.googleLoading = false,
    this.facebookLoading = false,
    this.appleLoading = false,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: child,
        ),
        child: FocusTraversalGroup(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, isDark ? 0.16 : 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        loc.loginTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildAnimatedSocialButton(
                      context,
                      icon: googleIcon ?? Icons.account_circle,
                      iconColor: googleColor ?? Colors.red,
                      label: googleLabel ?? loc.oauthSignIn,
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      borderColor: colorScheme.outline,
                      onPressed: isLoading ? null : onGoogle,
                      tooltip: loc.oauthSignIn,
                      loading: googleLoading,
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedSocialButton(
                      context,
                      icon: facebookIcon ?? Icons.facebook,
                      iconColor: facebookColor ?? Colors.blue[800]!,
                      label: facebookLabel ?? loc.signInWithFacebook,
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      borderColor: Colors.transparent,
                      onPressed: isLoading ? null : onFacebook,
                      tooltip: loc.signInWithFacebook,
                      loading: facebookLoading,
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedSocialButton(
                      context,
                      icon: appleIcon ?? Icons.apple,
                      iconColor: appleColor ?? Colors.white,
                      label: appleLabel ?? loc.signInWithApple,
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      borderColor: Colors.transparent,
                      onPressed: isLoading ? null : onApple,
                      tooltip: loc.signInWithApple,
                      loading: appleLoading,
                    ),
                    if (onGoogle == null &&
                        onFacebook == null &&
                        onApple == null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            Icon(Icons.sentiment_dissatisfied,
                                size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text(
                              loc.noSocialLogin,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: (errorMessage != null && errorMessage!.isNotEmpty)
                          ? Padding(
                              key: ValueKey(errorMessage),
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 8),
                              child: Semantics(
                                label: errorMessage,
                                liveRegion: true,
                                child: Text(
                                  errorMessage!,
                                  style: TextStyle(
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20),
                    _TermsPrivacyRow(
                      onTermsTap: onTermsTap,
                      onPrivacyTap: onPrivacyTap,
                    ),
                  ],
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 0.18),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

// Extracted Terms/Privacy row for clarity and reuse

  Widget _buildAnimatedSocialButton(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color borderColor,
    required VoidCallback? onPressed,
    String? tooltip,
    bool loading = false,
  }) {
    return Focus(
      child: _MicroInteractionButton(
        enabled: onPressed != null,
        child: _HoverAnimatedButton(
          child: _buildSocialButton(
            context,
            icon: icon,
            iconColor: iconColor,
            label: label,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            borderColor: borderColor,
            onPressed: onPressed,
            tooltip: tooltip,
            loading: loading,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color borderColor,
    required VoidCallback? onPressed,
    String? tooltip,
    bool loading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Tooltip(
        message: tooltip ?? label,
        child: ElevatedButton.icon(
          icon: loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                  ),
                )
              : Icon(icon, color: iconColor, size: 24),
          label: Text(label),
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            side: BorderSide(color: borderColor, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

class _MicroInteractionButton extends StatefulWidget {
  final Widget child;
  final bool enabled;
  const _MicroInteractionButton({required this.child, this.enabled = true});

  @override
  State<_MicroInteractionButton> createState() =>
      _MicroInteractionButtonState();
}

class _MicroInteractionButtonState extends State<_MicroInteractionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enabled) _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enabled) _controller.forward();
  }

  void _onTapCancel() {
    if (widget.enabled) _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

// Extracted Terms/Privacy row for clarity and reuse
class _TermsPrivacyRow extends StatelessWidget {
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  const _TermsPrivacyRow({this.onTermsTap, this.onPrivacyTap});
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final color = Theme.of(context).primaryColor;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        GestureDetector(
          onTap: onTermsTap ??
              () async {
                final url = Uri.parse('https://multisales.com/terms');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
          child: Text(
            loc.termsOfService,
            style: TextStyle(
              color: color,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const Text(
          '|',
          style: TextStyle(color: Colors.grey),
        ),
        GestureDetector(
          onTap: onPrivacyTap ??
              () async {
                final url = Uri.parse('https://multisales.com/privacy');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
          child: Text(
            loc.privacyPolicy,
            style: TextStyle(
              color: color,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

// Hover animation for web/desktop
class _HoverAnimatedButton extends StatefulWidget {
  final Widget child;
  const _HoverAnimatedButton({required this.child});
  @override
  State<_HoverAnimatedButton> createState() => _HoverAnimatedButtonState();
}

class _HoverAnimatedButtonState extends State<_HoverAnimatedButton> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
