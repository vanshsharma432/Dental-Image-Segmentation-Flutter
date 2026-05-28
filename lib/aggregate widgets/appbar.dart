import 'dart:ui';
import '../widgets/appbarbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  Function? onAboutUsPressed;
  CustomAppBar({super.key, this.onAboutUsPressed});

  static const double _navButtonSpacing = 16;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isVertical = height > width*1.2;
    return SliverAppBar(
      iconTheme: IconThemeData(color: const Color.fromARGB(128, 0, 0, 0), size: 24),
      forceMaterialTransparency: true,
      backgroundColor: Colors.transparent,
      floating: true,
      pinned: false,
      snap: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      leading: isVertical ? IconButton(
        padding: EdgeInsetsDirectional.only(end: -8),
        icon: SvgPicture.asset(
          'assets/vectors/block-quote_10742165.svg',
          colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ), //
        onPressed: () => Scaffold.of(context).openDrawer(),
      ) : null,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Theme.of(context).colorScheme.secondary.withOpacity(0.3)),
        ),
      ),
      title: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
        height: kToolbarHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: width*0.01),
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: Image.asset(
                      'assets/images/logo.webp',
                      fit: BoxFit.contain,
                      isAntiAlias: true,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dental',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Segmentation',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ?isVertical ? null : Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBarButton(
                    text: 'Home',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                  const SizedBox(width: _navButtonSpacing),
                  const AppBarButton(text: 'View Research', width: 140),
                  const SizedBox(width: _navButtonSpacing),
                  const AppBarButton(text: 'Downloads', width: 120),
                  const SizedBox(width: _navButtonSpacing),
                  AppBarButton(text: 'About Us', width: 120, onPressed: onAboutUsPressed != null? () => onAboutUsPressed!() : null),
                  const SizedBox(width: _navButtonSpacing),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(width: width*0.01),
                  ?isVertical ? null :Text(
                    'Anonymous',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

