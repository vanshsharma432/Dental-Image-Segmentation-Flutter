import 'package:flutter/material.dart';

class StaticRightCircularImageDisplay extends StatefulWidget {
	const StaticRightCircularImageDisplay({
		super.key,
		required this.imagePath,
		this.diameter = 220,
		this.rightPadding = 24,
		this.hoverScale = 1.1,
	});

	final String imagePath;
	final double diameter;
	final double rightPadding;
	final double hoverScale;

	@override
	State<StaticRightCircularImageDisplay> createState() =>
			_StaticRightCircularImageDisplayState();
}

class _StaticRightCircularImageDisplayState
		extends State<StaticRightCircularImageDisplay> {
	bool _isHovered = false;

	@override
	Widget build(BuildContext context) {
		return Align(
			alignment: Alignment.centerRight,
			child: Padding(
				padding: EdgeInsets.only(right: widget.rightPadding),
				child: MouseRegion(
					onEnter: (_) => setState(() => _isHovered = true),
					onExit: (_) => setState(() => _isHovered = false),
					child: AnimatedScale(
						duration: const Duration(milliseconds: 220),
						curve: Curves.easeOutCubic,
						scale: _isHovered ? widget.hoverScale : 1,
						child: ClipRRect(
							borderRadius: BorderRadius.circular(widget.diameter / 4),
							child: SizedBox(
								width: widget.diameter,
								height: widget.diameter,
								child: Image.asset(
									widget.imagePath,                  
									fit: BoxFit.cover,
									filterQuality: FilterQuality.high,
								),
							),
						),
					),
				),
			),
		);
	}
}
