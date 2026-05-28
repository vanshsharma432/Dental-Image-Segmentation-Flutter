import 'dart:ui';
import 'package:dental/aggregate%20widgets/home_screen_bottom_bar.dart';
import 'package:dental/aggregate%20widgets/appbar.dart';
import 'package:dental/widgets/home_screen_button.dart';
import 'package:dental/widgets/middlehomecard.dart';
import 'package:dental/widgets/static_right_circular.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  static final Uri _documentationUrl = Uri.parse('https://drive.google.com/file/d/1ec7j5Ky-ySSP9nXPyEIZZULiG8y9LNX_/view?usp=sharing');

  Future<void> _openDocumentation() async {
    final launched = await launchUrl(
      _documentationUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open documentation link')),
      );
    }
  }

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
      drawer: isVertical
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Documentation'),
                    onTap: () {
                      _openDocumentation();
                    },
                  ),
                ],
              ),
            )
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          CustomAppBar(onAboutUsPressed: _scrollToBottom),
          SliverFillRemaining(
            hasScrollBody: false,
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
                        stops: [0.0, 0.2, 0.5, 0.8, 1.0],
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
                ?isVertical
                    ? null
                    : StaticRightCircularImageDisplay(
                        imagePath:
                            "assets/images/igor-omilaev-eGGFZ5X2LnA-unsplash.webp",
                        rightPadding: 64,
                        diameter: 548,
                      ),
                Padding(
                  padding: isVertical
                      ? const EdgeInsets.symmetric(horizontal: 16, vertical: 64)
                      : const EdgeInsets.all(64.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        "DENTAL IMAGE\nSEGMENTATION",
                        style: Theme.of(context).textTheme.headlineLarge!
                            .copyWith(
                              fontSize: isVertical ? width * 0.13 : 100,
                              letterSpacing: -5,
                              wordSpacing: 12,
                              height: 1,
                            ),
                      ),
                      SizedBox(height: 32),
                      SelectableText(
                        "Models curated for one of the most crucial preprocessing tasks.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 32),
                      isVertical
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 24,
                              children: [
                                HomeScreenButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/loading'),
                                  text: "Get Started Now",
                                  bgcolor: Colors.white,
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: _openDocumentation,
                                  child: Text(
                                    "View Documentation",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                                SizedBox(height: 32),
                                StaticRightCircularImageDisplay(
                                  imagePath:
                                      "assets/images/igor-omilaev-eGGFZ5X2LnA-unsplash.webp",
                                  diameter: width * 0.8,
                                ),
                              ],
                            )
                          : Row(
                              spacing: 24,
                              children: [
                                HomeScreenButton(
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/loading'),
                                  text: "Get Started Now",
                                  bgcolor: Colors.white,
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: _openDocumentation,
                                  child: Text(
                                    "View Documentation",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Middlehomecard(
              expandedHeight: isVertical ? height * 0.9 : height * 0.4,
              collapsedHeight: isVertical ? height * 0.6 : height * 0.3,
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
