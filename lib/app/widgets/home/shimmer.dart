import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  const Shimmer({
    Key? key,
    required this.child,
    this.period = const Duration(milliseconds: 1200),
  }) : super(key: key);

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final width = bounds.width;
            final dx = (2 * _ctrl.value - 1) * width;
            return LinearGradient(
              begin: Alignment(-1 - dx/width, 0),
              end: Alignment(1 - dx/width, 0),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,  // <<– غيرناه من srcATop إلى srcIn
          child: widget.child,
        );
      },
    );
  }
}
