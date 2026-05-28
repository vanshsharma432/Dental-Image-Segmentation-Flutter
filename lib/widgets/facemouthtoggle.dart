import 'package:dental/backend/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Facemouthtoggle extends StatefulWidget {
  const Facemouthtoggle({super.key});

  @override
  State<Facemouthtoggle> createState() => _FacemouthtoggleState();
}

class _FacemouthtoggleState extends State<Facemouthtoggle> {
  
  bool isface = false;

  @override
  void initState() {
    super.initState();
    isface = context.read<MouthModelProvider>().getFace();
  }
  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        _ToggleOption(
          assetPath: 'assets/images/face.png',
          selected: isface,
          name: 'Face View',
          onTap: () {
            setState(() {
              isface = true;
              context.read<MouthModelProvider>().setFace();
            });
          },
        ),
        _ToggleOption(
          assetPath: 'assets/images/mouth.png',
          selected: !isface,
          name: 'Mouth View',
          onTap: () {
            setState(() {
              isface = false;
              context.read<MouthModelProvider>().setMouth();
            });
          },
        ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String assetPath;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.assetPath,
    required this.selected,
    required this.onTap,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withOpacity(0.5)
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? Colors.black.withOpacity(0.35)
                : Colors.white.withOpacity(0.15),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Image.asset(
              assetPath,
              height: 100,
              width: 200,
              color: selected ? Colors.blue : Colors.grey,
              isAntiAlias: true,
              colorBlendMode: BlendMode.overlay,
              filterQuality: FilterQuality.high,
            ),
            Text(name)
          ],
        ),
      ),
    );
  }
}
