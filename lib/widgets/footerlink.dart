import 'package:flutter/material.dart';

class Footerlink extends StatefulWidget {
  Footerlink({super.key, required this.text, required this.color});
  String text;
  Color color;

  @override
  State<Footerlink> createState() => _FooterlinkState();
}

class _FooterlinkState extends State<Footerlink> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovering = true),
      onHover: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.color,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            decoration: _isHovering ? TextDecoration.underline : TextDecoration.none,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
