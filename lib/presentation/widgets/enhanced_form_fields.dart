import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced TextFormField with accessibility improvements and better UX
class EnhancedTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? helperText;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final String? semanticLabel;
  final String? semanticHint;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? restorationId;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool filled;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final double borderRadius;

  const EnhancedTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.enabled = true,
    this.semanticLabel,
    this.semanticHint,
    this.focusNode,
    this.autofocus = false,
    this.restorationId,
    this.contentPadding,
    this.fillColor,
    this.filled = true,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.borderRadius = 12,
  });

  @override
  State<EnhancedTextFormField> createState() => _EnhancedTextFormFieldState();
}

class _EnhancedTextFormFieldState extends State<EnhancedTextFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  // Generate unique ID for accessibility
  String get _fieldId =>
      'field_${widget.labelText.toLowerCase().replaceAll(' ', '_')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: theme.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Semantics(
              identifier: _fieldId,
              label: widget.semanticLabel ?? widget.labelText,
              hint: widget.semanticHint ?? widget.hintText,
              textField: true,
              enabled: widget.enabled,
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                validator: widget.validator,
                onSaved: widget.onSaved,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                readOnly: widget.readOnly,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                restorationId: widget.restorationId,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: widget.enabled
                      ? null
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  helperText: widget.helperText,
                  prefixIcon: widget.prefixIcon != null
                      ? AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: IconTheme(
                            data: IconThemeData(
                              color: _isFocused
                                  ? theme.primaryColor
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                            child: widget.prefixIcon!,
                          ),
                        )
                      : null,
                  suffixIcon: widget.suffixIcon,
                  border: widget.border ??
                      OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                      ),
                  enabledBorder: widget.enabledBorder ??
                      OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                  focusedBorder: widget.focusedBorder ??
                      OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 2,
                        ),
                      ),
                  errorBorder: widget.errorBorder ??
                      OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          color: colorScheme.error,
                          width: 1,
                        ),
                      ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(
                      color: colorScheme.error,
                      width: 2,
                    ),
                  ),
                  filled: widget.filled,
                  fillColor: widget.fillColor ??
                      (_isFocused
                          ? colorScheme.surface
                          : colorScheme.surface.withValues(alpha: 0.8)),
                  contentPadding: widget.contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  labelStyle: TextStyle(
                    color: _isFocused
                        ? theme.primaryColor
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  helperStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Enhanced Password Field with visibility toggle
class EnhancedPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final bool autofocus;
  final String? semanticLabel;
  final String? semanticHint;
  final FocusNode? focusNode;

  const EnhancedPasswordField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.hintText,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.autofocus = false,
    this.semanticLabel,
    this.semanticHint,
    this.focusNode,
  });

  @override
  State<EnhancedPasswordField> createState() => _EnhancedPasswordFieldState();
}

class _EnhancedPasswordFieldState extends State<EnhancedPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return EnhancedTextFormField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autofocus: widget.autofocus,
      semanticLabel: widget.semanticLabel,
      semanticHint: widget.semanticHint,
      focusNode: widget.focusNode,
      prefixIcon: const Icon(Icons.lock_outlined),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      ),
    );
  }
}

/// Enhanced Button with loading state and accessibility
class EnhancedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final String? semanticLabel;
  final String? tooltip;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const EnhancedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.semanticLabel,
    this.tooltip,
    this.width,
    this.height = 56,
    this.padding,
  });

  @override
  State<EnhancedButton> createState() => _EnhancedButtonState();
}

class _EnhancedButtonState extends State<EnhancedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Semantics(
            label: widget.semanticLabel,
            button: true,
            enabled: widget.onPressed != null && !widget.isLoading,
            child: Tooltip(
              message: widget.tooltip ?? '',
              child: GestureDetector(
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) => _animationController.reverse(),
                onTapCancel: () => _animationController.reverse(),
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: ElevatedButton(
                    onPressed: widget.isLoading ? null : widget.onPressed,
                    style: widget.style ??
                        ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          padding: widget.padding ??
                              const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                        ),
                    child: widget.isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
