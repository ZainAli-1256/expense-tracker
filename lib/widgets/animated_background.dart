import 'package:flutter/material.dart';

/// Animated gradient background that loops smoothly
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;

  const AnimatedBackground({
    Key? key,
    required this.child,
    this.animationDuration = const Duration(seconds: 8),
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
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
              begin: Alignment(-1.0 + _controller.value * 2, -1.0),
              end: Alignment(-1.0 + _controller.value * 2, 1.0),
              colors: [
                const Color(0xFF1A1A2E),
                const Color(0xFF16213E).withOpacity(0.8),
                const Color(0xFF0F172A),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Static gradient background for simple use cases
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
            const Color(0xFF0F172A),
          ],
        ),
      ),
      child: child,
    );
  }
}
