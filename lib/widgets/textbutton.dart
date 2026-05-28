import 'package:flutter/material.dart';


class Textbutton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  const Textbutton({super.key, required this.text, this.onPressed, this.width, this.height});

  @override
  State<Textbutton> createState() => _TextbuttonState();
}

class _TextbuttonState extends State<Textbutton> {
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
            ? (Matrix4.identity()..scale(1.00))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          // Toggle border based on hover state
          border: Border.all(
            color: hovering ? Colors.white : Colors.transparent,
            width: 0.75,
          ),
          // Subtle shadow when popping
          boxShadow: hovering
              ? [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      94,
                      138,
                      114,
                    ).withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Material(
          color:
              Colors.transparent, // Keep it transparent to show your gradient
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onPressed?? () {},
            child: Container(
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
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: hovering ? FontWeight.w500 : FontWeight.w100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
