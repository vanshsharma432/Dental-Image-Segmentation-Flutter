import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HoverRevealCard extends StatefulWidget {
  const HoverRevealCard({
    super.key,
    required this.title,
    this.display,
    required this.body,
    this.onHoverChanged,
    this.collapsedWidth = 400,
    this.expandedWidth = 400,
    this.collapsedHeight = 150,
    this.expandedHeight = 240,
    this.duration = const Duration(milliseconds: 1100),
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.titleStyle,
    this.bodyStyle,
  });
  final String title;
  final String body;
  final String? display;
  final ValueChanged<bool>? onHoverChanged;
  final double collapsedWidth;
  final double expandedWidth;
  final double collapsedHeight;
  final double expandedHeight;
  final Duration duration;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  @override
  State<HoverRevealCard> createState() => _HoverRevealCardState();
}

class _HoverRevealCardState extends State<HoverRevealCard>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _iconButtonController;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _textAnimation;
  late final Animation<double> _rotateAnimation;
  bool _isHovered = false;
  bool _isPinnedExpanded = false;
  bool _ignoreHoverUntilExit = false;
  bool _lastReportedActiveState = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );

    _iconButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 800),
    );

    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );

    _textAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1.0, curve: Curves.easeInOut),
      reverseCurve: const Interval(0.0, 0.65, curve: Curves.easeInOut),
    );

    _rotateAnimation = CurvedAnimation(
      parent: _iconButtonController,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconButtonController.dispose();
    super.dispose();
  }

  bool get _isCardActive => _isHovered || _isPinnedExpanded;

  void _notifyActiveStateIfChanged() {
    final bool isActive = _isCardActive;
    if (isActive != _lastReportedActiveState) {
      _lastReportedActiveState = isActive;
      widget.onHoverChanged?.call(isActive);
    }
  }

  void _onEnter(PointerEnterEvent _) {
    if (_ignoreHoverUntilExit) {
      return;
    }
    if (!_isHovered) {
      _isHovered = true;
      _notifyActiveStateIfChanged();
    }
    if (!_isPinnedExpanded) {
      _controller.forward();
    }
  }

  void _onExit(PointerExitEvent _) {
    if (_isHovered) {
      _isHovered = false;
      _notifyActiveStateIfChanged();
    }
    if (_ignoreHoverUntilExit) {
      _ignoreHoverUntilExit = false;
    }
    if (!_isPinnedExpanded) {
      _controller.reverse();
    }
  }

  void _togglePinnedExpanded() {
    if (_isPinnedExpanded) {
      setState(() {
        _isPinnedExpanded = false;
        _isHovered = false;
        _ignoreHoverUntilExit = true;
      });
      _iconButtonController.reverse();
      _controller.reverse();
      _notifyActiveStateIfChanged();
      return;
    }

    setState(() {
      _isPinnedExpanded = true;
      _ignoreHoverUntilExit = false;
    });
    _iconButtonController.forward();
    _controller.forward();
    _notifyActiveStateIfChanged();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final width = Tween<double>(
            begin: widget.collapsedWidth,
            end: widget.expandedWidth,
          ).evaluate(_sizeAnimation);

          final height = Tween<double>(
            begin: widget.collapsedHeight,
            end: widget.expandedHeight,
          ).evaluate(_sizeAnimation);
          return Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(20),
            color: widget.backgroundColor ?? theme.colorScheme.surface,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1),
              curve: Curves.linear,
              width: width,
              height: height,
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style:
                              widget.titleStyle ?? theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: _togglePinnedExpanded,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                        splashRadius: 18,
                        icon: AnimatedBuilder(
                          animation: _rotateAnimation,
                          builder: (context, child) {
                            final _rotateAnimationTween = Tween<double>(
                              begin: 0,
                              end: 5* math.pi / 4,
                            ).evaluate(_rotateAnimation);
                            return Transform.rotate(
                              angle: _rotateAnimationTween,
                              child: Icon(Icons.add),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.display ?? "",
                    style: widget.titleStyle ?? theme.textTheme.bodyMedium,
                  ),
                  Expanded(
                    child: Opacity(
                      opacity: _textAnimation.value,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topLeft,
                          heightFactor: _textAnimation.value.clamp(0.0, 1.0),
                          child: Text(
                            widget.body,
                            style:
                                widget.bodyStyle ?? theme.textTheme.bodyMedium,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
