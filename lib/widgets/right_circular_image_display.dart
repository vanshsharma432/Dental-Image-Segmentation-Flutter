import 'package:flutter/material.dart';

class RightSideCircularImageDisplay extends StatefulWidget {
	const RightSideCircularImageDisplay({
		super.key,
		required this.imagePaths,
		this.diameter = 220,
		this.rightPadding = 24,
		this.animationDuration = const Duration(seconds: 64),
		this.hoverScale = 1.12,
	}) : assert(
				imagePaths.length == 4,
				'imagePaths must contain exactly 4 images.',
			);

	final List<String> imagePaths;
	final double diameter;
	final double rightPadding;
	final Duration animationDuration;
	final double hoverScale;

	@override
	State<RightSideCircularImageDisplay> createState() =>
			_RightSideCircularImageDisplayState();
}

class _RightSideCircularImageDisplayState extends State<RightSideCircularImageDisplay>
		with SingleTickerProviderStateMixin {
	late final AnimationController _controller;
	bool _isHovered = false;

	@override
	void initState() {
		super.initState();
		_controller = AnimationController(
			vsync: this,
			duration: widget.animationDuration,
		)..repeat();
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final double diameter = widget.diameter;
		final double stripHeight = diameter * widget.imagePaths.length;

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
						child: ClipOval(
							child: SizedBox(
								width: diameter,
								height: diameter,
								child: AnimatedBuilder(
									animation: _controller,
									builder: (context, _) {
										final double offset = _controller.value * stripHeight;

										return ShaderMask(
											shaderCallback: (rect) => const LinearGradient(
												begin: Alignment.topCenter,
												end: Alignment.bottomCenter,
												colors: [
													Colors.white,
													Colors.white,
													Color.fromARGB(10, 76, 78, 77),
												],
												stops: [0.0, 0.8, 1.0],
											).createShader(rect),
											blendMode: BlendMode.dstIn,
											child: Stack(
												fit: StackFit.expand,
												children: [
													Transform.translate(
														offset: Offset(0, -stripHeight + offset),
														child: _imageStrip(),
													),
													Transform.translate(
														offset: Offset(0, offset),
														child: _imageStrip(),
													),
												],
											),
										);
									},
								),
							),
						),
					),
				),
			),
		);
	}

	Widget _imageStrip() {
		return Column(
			children: widget.imagePaths
					.map(
						(path) => SizedBox(
							height: widget.diameter,
							width: widget.diameter,
							child: Image.asset(
								path,
								fit: BoxFit.cover,
								filterQuality: FilterQuality.high,
							),
						),
					)
					.toList(),
		);
	}
}
