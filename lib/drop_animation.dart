library drop_animation;

import 'package:flutter/material.dart';

/// A widget that displays a drop animation.
///
/// The animation simulates a drop falling and splashing at the bottom.
/// External interaction is possible via the static [triggerAddDrop] method.
class DropAnimationScreen extends StatefulWidget {
  /// The size of the drop.
  final Size dropSize;

  /// The vertical distance the drop will fall.
  final double dropHeight;

  /// The duration of the drop animation.
  final Duration dropDuration;

  /// The color of the drop.
  final Color dropColor;

  /// A global key to provide external access to the widget's state.
  static final GlobalKey<DropAnimationScreenState> globalKey =
      GlobalKey<DropAnimationScreenState>();

  /// Creates a [DropAnimationScreen].
  ///
  /// All parameters are optional and have default values.
  DropAnimationScreen({
    Key? key,
    this.dropSize = const Size(30, 40),
    this.dropHeight = 300,
    this.dropDuration = const Duration(milliseconds: 2000),
    this.dropColor = Colors.blue,
  }) : super(key: globalKey);

  /// Static method to trigger the addition of a new drop.
  static void triggerAddDrop() {
    globalKey.currentState?.addDrop();
  }

  @override
  State<DropAnimationScreen> createState() => DropAnimationScreenState();
}

/// Public state class to control the drop animation.
class DropAnimationScreenState extends State<DropAnimationScreen> {
  final List<int> dropIds = [];
  int dropCounter = 0;

  /// Adds a new drop to the animation.
  void addDrop() {
    setState(() {
      dropIds.add(dropCounter++);
    });
  }

  void _removeDrop(int id) {
    setState(() {
      dropIds.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Container height: dropHeight + dropSize.height
    final double containerHeight = widget.dropHeight + widget.dropSize.height;
    const double containerWidth = 200;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Stack(
            children: [
              // Each drop is represented by an AnimatedDrop widget with a unique id.
              for (int id in dropIds)
                AnimatedDrop(
                  key: ValueKey(id),
                  size: widget.dropSize,
                  dropHeight: widget.dropHeight,
                  dropDuration: widget.dropDuration,
                  dropColor: widget.dropColor,
                  onCompleted: () => _removeDrop(id),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that animates a single drop.
class AnimatedDrop extends StatefulWidget {
  /// The size of the drop.
  final Size size;

  /// The height at which the drop will complete its falling motion.
  final double dropHeight;

  /// The duration of the drop animation.
  final Duration dropDuration;

  /// The color of the drop.
  final Color dropColor;

  /// Callback invoked when the animation completes.
  final VoidCallback onCompleted;

  /// Creates an [AnimatedDrop] widget.
  const AnimatedDrop({
    Key? key,
    this.size = const Size(30, 40),
    this.dropHeight = 300,
    this.dropDuration = const Duration(milliseconds: 2000),
    required this.dropColor,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<AnimatedDrop> createState() => _AnimatedDropState();
}

class _AnimatedDropState extends State<AnimatedDrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _positionAnimation;
  late final Animation<double> _stretchAnimation;
  late final Animation<double> _splashScaleXAnimation;
  late final Animation<double> _splashScaleYAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.dropDuration,
    );

    _positionAnimation = Tween<double>(
      begin: 0,
      end: widget.dropHeight,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    _stretchAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _splashScaleXAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
      ),
    );

    _splashScaleYAnimation = Tween<double>(begin: 1.5, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted();
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
    const double containerWidth = 200;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double topPosition;
        double scaleX, scaleY;
        double dropOpacity;
        if (_controller.value < 0.7) {
          topPosition = _positionAnimation.value;
          scaleX = 1.0;
          scaleY = _stretchAnimation.value;
          dropOpacity = 1.0;
        } else {
          topPosition = widget.dropHeight;
          scaleX = _splashScaleXAnimation.value;
          scaleY = _splashScaleYAnimation.value;
          dropOpacity = _opacityAnimation.value;
        }
        return Positioned(
          left: (containerWidth - widget.size.width) / 2,
          top: topPosition,
          child: Opacity(
            opacity: dropOpacity,
            child: Transform.scale(
              scaleX: scaleX,
              scaleY: scaleY,
              child: CustomPaint(
                size: widget.size,
                painter: DropPainter(dropColor: widget.dropColor),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A custom painter that draws a drop shape.
class DropPainter extends CustomPainter {
  /// The color used to paint the drop.
  final Color dropColor;

  /// Creates a [DropPainter] with the given [dropColor].
  DropPainter({required this.dropColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dropColor;
    final double w = size.width;
    final double h = size.height;
    final double radius = w / 2;
    final Offset arcCenter = Offset(w / 2, h - radius);

    Path path = Path();
    // Top point of the drop.
    path.moveTo(w / 2, 0);
    // Right curve: from the top to the bottom-right.
    path.quadraticBezierTo(w, (h - radius) * 0.6, w, h - radius);
    // Bottom semicircle.
    Rect arcRect = Rect.fromCircle(center: arcCenter, radius: radius);
    path.addArc(arcRect, 0, 3.14159);
    // Left curve: from the bottom-left back to the top.
    path.quadraticBezierTo(0, (h - radius) * 0.6, w / 2, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
