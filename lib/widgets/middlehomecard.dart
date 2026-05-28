import 'package:flutter/material.dart';
import 'collapsedcard.dart';

class Middlehomecard extends StatefulWidget {
  const Middlehomecard({
    super.key,
    this.collapsedHeight = 300,
    this.expandedHeight = 400,
  });

  final double collapsedHeight;
  final double expandedHeight;

  @override
  State<Middlehomecard> createState() => _MiddlehomecardState();
}

class _MiddlehomecardState extends State<Middlehomecard> {
  final Set<int> _activeCards = <int>{};

  bool get hasActiveCard => _activeCards.isNotEmpty;

  void _onCardHoverChanged(int index, bool isActive) {
    final bool changed;
    if (isActive) {
      changed = _activeCards.add(index);
    } else {
      changed = _activeCards.remove(index);
    }

    if (changed && mounted) {
      setState(() {});
    }
  }

  List<_MiddleCardContent> get _cards => const [
    _MiddleCardContent(
      title: 'Applications',
      body:
          '• Dental Disease Diagnosis\n• Treatment Planning\n• Forensic Odontology\n• Dental Biometrics',
      display:
          'Dental Image Segmentation is a prerequisite for various dental applications which pave way for further automation in this field',
    ),
    _MiddleCardContent(
      title: 'Challenges',
      body:
          '• Inconsist lightning conditions\n• Hardware Variations\n• Morphological Variations\n• Lack of Data',
      display:
          'Dental image segmentation is a complex task due to the intricate structures and variations in dental anatomy.',
    ),
    _MiddleCardContent(
      title: 'Future Scope',
      body:
          '• Dataset Expansion and Generalisation\n• Real-time Processing\n• Improved Accuracy\n• Video Data Analysis',
      display:
          'The future of dental image segmentation holds promise for more accurate and efficient diagnostic tools.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isVertical = constraints.maxWidth < 920;
        final double sidePadding = isVertical ? 16 : 24;
        final double spacing = isVertical ? 16 : 32;
        final double availableWidth = constraints.maxWidth - (sidePadding * 2);
        final double cardWidth = isVertical
            ? availableWidth
            : ((availableWidth - (spacing * 2)) / 3).clamp(220, 420).toDouble();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutQuad,
          constraints: BoxConstraints(
            maxHeight: isVertical
                ? (hasActiveCard
                      ? widget.expandedHeight
                      : widget.collapsedHeight)
                : (hasActiveCard
                      ? widget.expandedHeight + 100 * _activeCards.length
                      : widget.collapsedHeight),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sidePadding,
              vertical: 32,
            ),
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.center,
              children: List.generate(_cards.length, (index) {
                final _MiddleCardContent card = _cards[index];
                return SizedBox(
                  width: cardWidth,
                  child: HoverRevealCard(
                    title: card.title,
                    body: card.body,
                    display: card.display,
                    collapsedWidth: cardWidth,
                    expandedWidth: cardWidth,
                    collapsedHeight: 150,
                    expandedHeight: 240,
                    onHoverChanged: (isActive) =>
                        _onCardHoverChanged(index, isActive),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class _MiddleCardContent {
  const _MiddleCardContent({
    required this.title,
    required this.body,
    required this.display,
  });

  final String title;
  final String body;
  final String display;
}
