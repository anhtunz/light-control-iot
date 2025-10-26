import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AnimatedNeumorphicButton extends StatefulWidget {
  final bool isActive;
  final bool isUp;
  final IconData icon;
  final VoidCallback? onPressed;

  const AnimatedNeumorphicButton({
    super.key,
    required this.icon,
    required this.isUp,
    required this.isActive,
    this.onPressed,
  });

  @override
  State<AnimatedNeumorphicButton> createState() =>
      _AnimatedNeumorphicButtonState();
}

class _AnimatedNeumorphicButtonState extends State<AnimatedNeumorphicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Animation di chuyển icon lên trên
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.isUp ? Offset(0, -2) : Offset(0, 2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animation opacity để icon biến mất rồi xuất hiện
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
  }

  bool _currentColor = false; // Track current color state

  @override
  void didUpdateWidget(AnimatedNeumorphicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      _startAnimation();
    }
  }

  void _startAnimation() async {
    await _controller.forward();
    _controller.reset();
    setState(() {
      _currentColor = widget.isActive; // Cập nhật màu sau khi animation xong
    });
  }

  void _handleTap() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: const EdgeInsets.all(30),
      style: NeumorphicStyle(
        color: widget.isActive ? Colors.yellow[300] : Color(0xFFE0E6E6),
        // disableDepth: true,
        lightSource:
            widget.isUp ? LightSource.bottomRight : LightSource.bottomLeft,
        depth: 18,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        shape: NeumorphicShape.convex,
        // surfaceIntensity: 0.6,
        // intensity: 0.8
        // oppositeShadowLightSource: true
      ),
      onPressed: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value * 30,
            child: AnimatedOpacity(
              opacity: _controller.isAnimating ? _opacityAnimation.value : 1.0,
              duration: const Duration(milliseconds: 50),
              child: Icon(
                size: 30,
                widget.icon,
                color: _currentColor ? Colors.red : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
