import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:dental/backend/api.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Timer _wakeUpPoller;
  bool _isNavigating = false;
  bool _isCheckingWakeup = false;

  Future<void> _checkWakeupAndNavigate() async {
    if (!mounted || _isNavigating || _isCheckingWakeup) return;

    _isCheckingWakeup = true;
    final bool loaded = await Api().wakeUpServer();
    _isCheckingWakeup = false;

    if (!mounted || _isNavigating || !loaded) return;

    _isNavigating = true;
    _wakeUpPoller.cancel();
    Navigator.pushReplacementNamed(context, '/prediction');
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _checkWakeupAndNavigate();
    _wakeUpPoller = Timer.periodic(const Duration(seconds: 2), (_) {
      _checkWakeupAndNavigate();
    });
  }

  @override
  void dispose() {
    _wakeUpPoller.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color secondary = Theme.of(context).colorScheme.secondary;
    final Color surface = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: surface),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double progress = _controller.value;
              return CustomPaint(
                painter: _AuroraPainter(
                  progress: progress,
                  primary: primary,
                  secondary: secondary,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.1),
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    surface.withOpacity(0.22),
                    surface.withOpacity(0.78),
                  ],
                  stops: const [0.35, 0.78, 1.0],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                    backgroundColor: primary.withOpacity(0.15),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Loading',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  const _AuroraPainter({
    required this.progress,
    required this.primary,
    required this.secondary,
  });

  final double progress;
  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final double phase = progress * 2 * pi;

    void paintBlob({
      required Offset center,
      required double radius,
      required List<Color> colors,
      required List<double> stops,
    }) {
      final Rect rect = Rect.fromCircle(center: center, radius: radius);
      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: colors,
          stops: stops,
        ).createShader(rect)
        ..blendMode = BlendMode.screen;
      canvas.drawCircle(center, radius, paint);
    }

    // Large soft aurora ribbons that drift and overlap.
    paintBlob(
      center: Offset(
        size.width * (0.18 + 0.06 * sin(phase)),
        size.height * (0.24 + 0.05 * cos(phase * 0.8)),
      ),
      radius: size.shortestSide * 0.52,
      colors: [
        primary.withOpacity(0.00),
        primary.withOpacity(0.22),
        primary.withOpacity(0.05),
      ],
      stops: const [0.0, 0.48, 1.0],
    );

    paintBlob(
      center: Offset(
        size.width * (0.82 - 0.08 * cos(phase * 0.7)),
        size.height * (0.22 + 0.06 * sin(phase * 0.9)),
      ),
      radius: size.shortestSide * 0.48,
      colors: [
        secondary.withOpacity(0.00),
        secondary.withOpacity(0.28),
        secondary.withOpacity(0.04),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    paintBlob(
      center: Offset(
        size.width * (0.5 + 0.10 * sin(phase * 0.6 + pi / 3)),
        size.height * (0.50 + 0.08 * cos(phase * 0.65)),
      ),
      radius: size.shortestSide * 0.62,
      colors: [
        primary.withOpacity(0.00),
        secondary.withOpacity(0.14),
        primary.withOpacity(0.00),
      ],
      stops: const [0.0, 0.45, 1.0],
    );

    paintBlob(
      center: Offset(
        size.width * (0.52 + 0.12 * cos(phase * 0.45)),
        size.height * (0.82 + 0.03 * sin(phase * 0.75)),
      ),
      radius: size.shortestSide * 0.42,
      colors: [
        secondary.withOpacity(0.00),
        primary.withOpacity(0.12),
        secondary.withOpacity(0.00),
      ],
      stops: const [0.0, 0.55, 1.0],
    );

    // Subtle horizontal glow strip for depth.
    final Rect bandRect = Rect.fromLTWH(0, size.height * 0.25, size.width, size.height * 0.5);
    final Paint bandPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          primary.withOpacity(0.02),
          secondary.withOpacity(0.10),
          primary.withOpacity(0.02),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(bandRect)
      ..blendMode = BlendMode.screen;
    canvas.drawRect(bandRect, bandPaint);
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary;
  }
}
