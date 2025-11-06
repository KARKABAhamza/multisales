// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom animated loading indicator with multiple styles
class CustomLoadingIndicator extends StatefulWidget {
  final LoadingStyle style;
  final Color? color;
  final double size;
  final Duration duration;

  const CustomLoadingIndicator({
    super.key,
    this.style = LoadingStyle.dots,
    this.color,
    this.size = 50,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    switch (widget.style) {
      case LoadingStyle.dots:
        return _buildDotsIndicator(color);
      case LoadingStyle.pulse:
        return _buildPulseIndicator(color);
      case LoadingStyle.wave:
        return _buildWaveIndicator(color);
      case LoadingStyle.spinner:
        return _buildSpinnerIndicator(color);
      case LoadingStyle.bounce:
        return _buildBounceIndicator(color);
    }
  }

  Widget _buildDotsIndicator(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size / 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              final delay = index * 0.2;
              final progress = (_controller.value + delay) % 1.0;
              final scale = 0.5 + 0.5 * math.sin(progress * 2 * math.pi);

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size / 8,
                  height: widget.size / 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildPulseIndicator(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveIndicator(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final delay = index * 0.1;
              final progress = (_controller.value + delay) % 1.0;
              final height = 0.3 + 0.7 * math.sin(progress * 2 * math.pi);

              return Container(
                width: widget.size / 10,
                height: widget.size / 2 * height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(widget.size / 20),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildSpinnerIndicator(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border(
                  top: BorderSide(color: color, width: 3),
                  right: BorderSide.none,
                  bottom: BorderSide.none,
                  left: BorderSide.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBounceIndicator(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final bounceHeight = math.sin(_controller.value * 2 * math.pi).abs();
        return Transform.translate(
          offset: Offset(0, -widget.size / 4 * bounceHeight),
          child: Container(
            width: widget.size / 3,
            height: widget.size / 3,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

enum LoadingStyle { dots, pulse, wave, spinner, bounce }

/// Animated gradient background
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    required this.colors,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
              stops: [
                _controller.value * 0.3,
                0.5 + _controller.value * 0.2,
                0.8 + _controller.value * 0.2,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Custom floating action button with ripple animation
class CustomFloatingButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final bool showRipple;

  const CustomFloatingButton({
    super.key,
    this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 56,
    this.showRipple = true,
  });

  @override
  State<CustomFloatingButton> createState() => _CustomFloatingButtonState();
}

class _CustomFloatingButtonState extends State<CustomFloatingButton>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _scaleController;
  late Animation<double> _rippleAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onPressed != null) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });

      if (widget.showRipple) {
        _rippleController.forward().then((_) {
          _rippleController.reset();
        });
      }

      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rippleAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (widget.showRipple) ...[
              Transform.scale(
                scale: _rippleAnimation.value,
                child: Container(
                  width: widget.size * 1.5,
                  height: widget.size * 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (widget.backgroundColor ??
                            Theme.of(context).colorScheme.primary)
                        .withOpacity(0.3 * (1 - _rippleAnimation.value)),
                  ),
                ),
              ),
            ],
            Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: _handleTap,
                onTapDown: (_) => _scaleController.forward(),
                onTapUp: (_) => _scaleController.reverse(),
                onTapCancel: () => _scaleController.reverse(),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ??
                        Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: IconTheme(
                      data: IconThemeData(
                        color: widget.foregroundColor ?? Colors.white,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Animated progress indicator with custom design
class CustomProgressIndicator extends StatefulWidget {
  final double progress;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final String? label;
  final bool showPercentage;
  final Duration animationDuration;

  const CustomProgressIndicator({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 8,
    this.label,
    this.showPercentage = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<CustomProgressIndicator> createState() =>
      _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentProgress = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.progress)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(CustomProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: _currentProgress, end: widget.progress)
          .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (widget.showPercentage) ...[
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    _currentProgress = _animation.value;
                    return Text(
                      '${(_currentProgress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                    );
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ??
                        Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.height / 2),
                    child: LinearProgressIndicator(
                      value: _animation.value,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.foregroundColor ??
                            Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Particle animation effect
class ParticleAnimation extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color particleColor;
  final double particleSize;

  const ParticleAnimation({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.particleColor = Colors.blue,
    this.particleSize = 2,
  });

  @override
  State<ParticleAnimation> createState() => _ParticleAnimationState();
}

class _ParticleAnimationState extends State<ParticleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    final random = math.Random();
    particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        vx: (random.nextDouble() - 0.5) * 0.02,
        vy: (random.nextDouble() - 0.5) * 0.02,
        opacity: random.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(
                particles: particles,
                color: widget.particleColor,
                size: widget.particleSize,
                animation: _controller.value,
              ),
              child: Container(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  double x, y, vx, vy, opacity;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.opacity,
  });

  void update() {
    x += vx;
    y += vy;

    if (x < 0 || x > 1) vx *= -1;
    if (y < 0 || y > 1) vy *= -1;

    x = x.clamp(0.0, 1.0);
    y = y.clamp(0.0, 1.0);
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;
  final double size;
  final double animation;

  ParticlePainter({
    required this.particles,
    required this.color,
    required this.size,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()..color = color;

    for (final particle in particles) {
      particle.update();

      paint.color = color.withOpacity(particle.opacity * 0.7);
      canvas.drawCircle(
        Offset(
          particle.x * canvasSize.width,
          particle.y * canvasSize.height,
        ),
        size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Morphing shape animation
class MorphingShape extends StatefulWidget {
  final List<ShapeData> shapes;
  final Duration duration;
  final Color color;
  final double size;

  const MorphingShape({
    super.key,
    required this.shapes,
    this.duration = const Duration(seconds: 2),
    this.color = Colors.blue,
    this.size = 100,
  });

  @override
  State<MorphingShape> createState() => _MorphingShapeState();
}

class _MorphingShapeState extends State<MorphingShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int currentShapeIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            currentShapeIndex = (currentShapeIndex + 1) % widget.shapes.length;
          });
          _controller.reset();
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MorphingShapePainter(
            currentShape: widget.shapes[currentShapeIndex],
            nextShape:
                widget.shapes[(currentShapeIndex + 1) % widget.shapes.length],
            progress: _controller.value,
            color: widget.color,
          ),
          size: Size(widget.size, widget.size),
        );
      },
    );
  }
}

class ShapeData {
  final List<Offset> points;
  final String name;

  ShapeData({required this.points, required this.name});

  static ShapeData circle(double radius) {
    final points = <Offset>[];
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      points.add(Offset(
        radius + radius * math.cos(angle),
        radius + radius * math.sin(angle),
      ));
    }
    return ShapeData(points: points, name: 'circle');
  }

  static ShapeData square(double size) {
    return ShapeData(
      points: [
        const Offset(0, 0),
        Offset(size, 0),
        Offset(size, size),
        Offset(0, size),
        const Offset(0, 0),
        Offset(size, 0),
        Offset(size, size),
        Offset(0, size),
      ],
      name: 'square',
    );
  }

  static ShapeData triangle(double size) {
    return ShapeData(
      points: [
        Offset(size / 2, 0),
        Offset(size, size),
        Offset(0, size),
        Offset(size / 2, 0),
        Offset(size / 2, 0),
        Offset(size, size),
        Offset(0, size),
        Offset(size / 2, 0),
      ],
      name: 'triangle',
    );
  }
}

class MorphingShapePainter extends CustomPainter {
  final ShapeData currentShape;
  final ShapeData nextShape;
  final double progress;
  final Color color;

  MorphingShapePainter({
    required this.currentShape,
    required this.nextShape,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    for (int i = 0; i < currentShape.points.length; i++) {
      final currentPoint = currentShape.points[i];
      final nextPoint = nextShape.points[i % nextShape.points.length];

      final interpolatedPoint = Offset.lerp(currentPoint, nextPoint, progress)!;

      if (i == 0) {
        path.moveTo(interpolatedPoint.dx, interpolatedPoint.dy);
      } else {
        path.lineTo(interpolatedPoint.dx, interpolatedPoint.dy);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Breathing animation effect
class BreathingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const BreathingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}
