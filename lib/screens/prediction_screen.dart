import 'dart:ui';
import 'package:dental/aggregate%20widgets/appbar.dart';
import 'package:dental/aggregate%20widgets/home_screen_bottom_bar.dart';
import 'package:dental/aggregate%20widgets/imagepicker.dart';
import 'package:flutter/material.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool isVertical = height > width;
    final double appBarOverlap =
        MediaQuery.of(context).padding.top + kToolbarHeight;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          CustomAppBar(onAboutUsPressed: _scrollToBottom,),
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  top: -appBarOverlap,
                  child: Container(
                    height: height * 0.9 + appBarOverlap,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                        colors: [
                          const Color.fromARGB(10, 110, 224, 169),
                          const Color.fromARGB(100, 110, 224, 169),
                          Theme.of(context).colorScheme.secondary,
                          const Color.fromARGB(100, 110, 224, 169),
                          const Color.fromARGB(10, 110, 224, 169),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: -appBarOverlap,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset(
                        'assets/images/jean-philippe-delberghe-75xPHEQBmvA-unsplash.webp',
                        fit: BoxFit.cover,
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.5),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [const Imagepicker()],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: isVertical
                ? null
                : HomeScreenBottomBar(height: height, width: width),
          ),
        ],
      ),
    );
  }
}
