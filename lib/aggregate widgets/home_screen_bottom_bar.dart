import 'package:flutter/material.dart';
import '../widgets/concavefooter.dart';
import '../widgets/wavyfooter.dart';
import '../widgets/footerlink.dart';

class HomeScreenBottomBar extends StatefulWidget {
  final double? height;
  final double? width;
  const HomeScreenBottomBar({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  State<HomeScreenBottomBar> createState() => _HomeScreenBottomBarState();
}

class _HomeScreenBottomBarState extends State<HomeScreenBottomBar> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Message sent')));
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final headingColor = isDark ? Colors.white : Colors.black;
    final linkColor = isDark ? Colors.white70 : Colors.black54;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(300, 200),
            painter: ConcavePainter(),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: 400,
              width: double.infinity,
            ),
          ),
          CustomPaint(
            size: const Size(300, 200),
            painter: WavyFooterPainter(),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: 400,
              width: double.infinity,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 200, width: double.infinity),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Contact Us Anonymously Section
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Text(
                          "Contact Us Anonymously",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: headingColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(
                          height: 72,
                          width: widget.width! * 0.22,
                          child: TextField(
                            controller: _messageController,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.black87, fontSize: 13),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                            decoration: InputDecoration(
                              hintText: "Your Message",
                              hintStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              suffixIcon: IconButton(
                                onPressed: _sendMessage,
                                icon: Icon(
                                  Icons.send,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                minWidth: 48,
                                minHeight: 48,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(28.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    // Grouped Learn, Contact Us, and Account Sections
                    Wrap(
                      spacing: 40.0,
                      runSpacing: 20.0,
                      children: [
                        // Learn Section
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              "Learn",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: headingColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                            ),
                            Footerlink(text: "Dental Health", color: linkColor),
                            Footerlink(text: "Segmentation", color: linkColor),
                            Footerlink(text: "CNN", color: linkColor),
                          ],
                        ),
                        // Contact Us Section
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              "Contact Us",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: headingColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                            ),
                            Footerlink(text: "View History",color: linkColor),
                            Footerlink(text: "Learn More",color: linkColor),
                          ],
                        ),
                        // Account Section
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(
                              "Account",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: headingColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                            ),
                            Footerlink(text: "Change Username",color: linkColor),
                            Footerlink(text: "Change Password",color: linkColor),
                            Footerlink(
                              text: "Change Profile Picture",
                              color: linkColor,
                            ),
                            Footerlink(text: "Change Email",color:  linkColor),
                            Footerlink(text: "Delete Account",color: linkColor),
                          ],
                        ),
                        SizedBox(width: 40),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
