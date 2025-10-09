import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/cyberpunk_theme.dart';

/// Neon Pulse Animation - Glowing text that breathes
class NeonPulseText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color? glowColor;

  const NeonPulseText({
    super.key,
    required this.text,
    this.style,
    this.glowColor,
  });

  @override
  State<NeonPulseText> createState() => _NeonPulseTextState();
}

class _NeonPulseTextState extends State<NeonPulseText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.glowColor ?? CyberpunkTheme.neonCyan;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.text,
          style: widget.style?.copyWith(
                shadows: [
                  Shadow(
                    color: color.withOpacity(_animation.value * 0.8),
                    blurRadius: 5,
                  ),
                  Shadow(
                    color: color.withOpacity(_animation.value * 0.6),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: color.withOpacity(_animation.value * 0.4),
                    blurRadius: 20,
                  ),
                ],
              ) ??
              TextStyle(
                shadows: [
                  Shadow(
                    color: color.withOpacity(_animation.value * 0.8),
                    blurRadius: 5,
                  ),
                  Shadow(
                    color: color.withOpacity(_animation.value * 0.6),
                    blurRadius: 10,
                  ),
                  Shadow(
                    color: color.withOpacity(_animation.value * 0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
        );
      },
    );
  }
}

/// Glitch/Flicker Effect - Random flicker like old neon signs
class GlitchFlicker extends StatefulWidget {
  final Widget child;
  final Duration flickerInterval;

  const GlitchFlicker({
    super.key,
    required this.child,
    this.flickerInterval = const Duration(seconds: 5),
  });

  @override
  State<GlitchFlicker> createState() => _GlitchFlickerState();
}

class _GlitchFlickerState extends State<GlitchFlicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFlickering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _startFlickerLoop();
  }

  void _startFlickerLoop() async {
    while (mounted) {
      await Future.delayed(widget.flickerInterval);
      if (!mounted) break;

      setState(() => _isFlickering = true);

      // Flicker pattern: on-off-on-off-on
      await _controller.forward();
      await Future.delayed(const Duration(milliseconds: 50));
      await _controller.reverse();
      await Future.delayed(const Duration(milliseconds: 50));
      await _controller.forward();
      await Future.delayed(const Duration(milliseconds: 50));
      await _controller.reverse();

      setState(() => _isFlickering = false);
      await _controller.forward();
    }
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
        return Opacity(
          opacity: _isFlickering ? _controller.value : 1.0,
          child: widget.child,
        );
      },
    );
  }
}

/// Cyber Glitch Shake - Subtle distortion effect
class CyberGlitch extends StatefulWidget {
  final Widget child;
  final Duration interval;

  const CyberGlitch({
    super.key,
    required this.child,
    this.interval = const Duration(seconds: 8),
  });

  @override
  State<CyberGlitch> createState() => _CyberGlitchState();
}

class _CyberGlitchState extends State<CyberGlitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _startGlitchLoop();
  }

  void _startGlitchLoop() async {
    while (mounted) {
      await Future.delayed(widget.interval);
      if (!mounted) break;

      // Random glitch direction
      final random = math.Random();
      final dx = (random.nextDouble() - 0.5) * 4;
      final dy = (random.nextDouble() - 0.5) * 4;

      _animation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(dx, dy),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ));

      await _controller.forward();
      await _controller.reverse();
    }
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
        return Transform.translate(
          offset: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Grid Scan Background - Moving scanlines
class GridScanBackground extends StatefulWidget {
  final Widget child;
  final Color? lineColor;

  const GridScanBackground({
    super.key,
    required this.child,
    this.lineColor,
  });

  @override
  State<GridScanBackground> createState() => _GridScanBackgroundState();
}

class _GridScanBackgroundState extends State<GridScanBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
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
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _GridScanPainter(
                    progress: _controller.value,
                    lineColor: widget.lineColor ??
                        CyberpunkTheme.neonCyan.withOpacity(0.03),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _GridScanPainter extends CustomPainter {
  final double progress;
  final Color lineColor;

  _GridScanPainter({
    required this.progress,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    // Horizontal lines moving down
    const lineSpacing = 2.0;
    final offset = progress * size.height;

    for (double y = -lineSpacing;
        y < size.height + lineSpacing;
        y += lineSpacing) {
      final adjustedY = (y + offset) % (size.height + lineSpacing);
      canvas.drawLine(
        Offset(0, adjustedY),
        Offset(size.width, adjustedY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GridScanPainter oldDelegate) => true;
}

/// Gradient Shift Animation - Animated color gradients
class GradientShift extends StatefulWidget {
  final Widget child;
  final List<Color> colors;

  const GradientShift({
    super.key,
    required this.child,
    required this.colors,
  });

  @override
  State<GradientShift> createState() => _GradientShiftState();
}

class _GradientShiftState extends State<GradientShift>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
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
                0.0,
                _controller.value * 0.5,
                _controller.value,
                1.0,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Neon Border Glow - Animated glowing border
class NeonBorderGlow extends StatelessWidget {
  final Widget child;
  final Color? glowColor;
  final double borderWidth;
  final double borderRadius;

  const NeonBorderGlow({
    super.key,
    required this.child,
    this.glowColor,
    this.borderWidth = 2,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    final color = glowColor ?? CyberpunkTheme.neonCyan;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: borderWidth,
        ),
        boxShadow: CyberpunkTheme.neonGlow(color: color),
      ),
      child: child,
    );
  }
}
