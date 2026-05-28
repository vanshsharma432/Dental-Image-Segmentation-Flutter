import 'package:flutter/material.dart';


class AppBarButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? scale;
  const AppBarButton({super.key, required this.text, this.onPressed, this.width, this.height, this.scale = 1});
  @override
  State<AppBarButton> createState() => _AppBarButtonState();
}

class _AppBarButtonState extends State<AppBarButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        height: widget.height,
        width: widget.width, // Base width on text length
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        // This creates the "Pop" effect by scaling up 5%
        transform: hovering
            ? (Matrix4.identity().scaledByDouble(1, widget.scale!, 1, 1))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(hovering ? 1 : 0.2),
            width: 1,
          ),
        ),
        child: Material(
          color:
              Colors.transparent, // Keep it transparent to show your gradient
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onPressed?? () {},
            child: Container(
              alignment: Alignment.center,
              height: 36,
              width: 88,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(hovering ? 0.6 : 0.4),
                    Colors.white.withOpacity(hovering ? 0.3 : 0.2),
                  ],
                ),
              ),
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: hovering ? FontWeight.w800 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
