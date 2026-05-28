import 'package:flutter/material.dart';

class HomeScreenButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? bgcolor;
  final double? width;
  final double? height;
  const HomeScreenButton({super.key, this.text = "Get Started Now", required this.onPressed, this.bgcolor, this.width, this.height});

  @override
  State<HomeScreenButton> createState() => _HomeScreenButtonState();
}

class _HomeScreenButtonState extends State<HomeScreenButton> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.bgcolor ?? (hovering ? Colors.white.withAlpha(255): Colors.white.withAlpha(240)),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: hovering ? 5 : 0,
          fixedSize: Size(widget.width ?? 200, widget.height ?? 40),
          side: BorderSide(color: Colors.black.withOpacity(hovering ? 0.8 : 0.2), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),),
        ),
        onPressed: widget.onPressed,
        child: Text(
          widget.text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: hovering ? FontWeight.w800:FontWeight.w600),
        ),
      ),
    );
  }
}
