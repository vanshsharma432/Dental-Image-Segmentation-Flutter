import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/imageservice.dart';
import 'dart:typed_data';
import 'package:dental/widgets/modelselector.dart';
import 'package:dental/widgets/facemouthtoggle.dart';
import 'package:dental/backend/api.dart';
import 'package:dental/backend/providers.dart';

class Imagepicker extends StatefulWidget {
  const Imagepicker({super.key});

  @override
  State<Imagepicker> createState() => _ImagepickerState();
}

class _ImagepickerState extends State<Imagepicker> {
  bool _isPicking = false;
  bool _isSelected = false;
  bool _isPredicting = false;
  Uint8List? imageBytes;
  Uint8List? _predictedBytes;
  final ImageService _imageService = ImageService();
  void _handleImageUpload() async {
    // 1. Show loading indicator
    setState(() {
      _isPicking = true;
    });

    // 2. Open the browser's file explorer
    final pickedImage = await _imageService.pickImageForWeb();

    // 3. Safety check: Did the user close the app before picking?
    if (!mounted) return;

    // 4. Turn off loading indicator
    setState(() {
      _isPicking = false;
    });

    // 5. If they actually picked an image, update preview and provider
    if (pickedImage != null) {
      setState(() {
        imageBytes = pickedImage;
        _isSelected = true;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No image selected.')));
    }
  }

  Future<void> _handlePredict() async {
    if (imageBytes == null) return;
    setState(() {
      _isPredicting = true;
    });

    final model = context.read<ModelProvider>().getModel();
    final face = context.read<MouthModelProvider>().getFace();
    try {
      final resp = await Api().predict(imageBytes!, model, face);
      if (!mounted) return;
      setState(() {
        _predictedBytes = resp;
      });
      if (resp.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Prediction failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Prediction error: $e')));
    } finally {
      if (mounted) setState(() => _isPredicting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final windowSize = MediaQuery.sizeOf(context);
        const double topControlsHeight = 120;
        final availableHeight = (windowSize.height - topControlsHeight)
          .clamp(0.0, double.infinity);
        final bool useColumnLayout =
            windowSize.width / windowSize.height < (12 / 9);
        return SizedBox(
          height: useColumnLayout? availableHeight*2 : availableHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 28,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    Wrap(
                      direction: Axis.vertical,
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 16,
                      children: [
                        SizedBox(
                          width: 260,
                          child: _isPicking
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton.icon(
                                  onPressed: _handleImageUpload,
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Select File'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    textStyle: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                        ),
                        const Modelselector(),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const Facemouthtoggle(),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 160,
                      child: ElevatedButton.icon(
                        onPressed: (_isPredicting || !_isSelected)
                            ? null
                            : _handlePredict,
                        icon: _isPredicting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow, size: 50),
                        label: Text('Predict', style: Theme.of(context).textTheme.headlineSmall),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(12, 16, 20, 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: useColumnLayout
                    ? Column(
                        children: [
                          Expanded(
                            child: _PreviewPanel(
                              width: constraints.maxWidth,
                              title: 'Selected image',
                              child: imageBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.memory(
                                        imageBytes!,
                                        fit: BoxFit.contain,
                                        gaplessPlayback: true,
                                        errorBuilder:
                                            (
                                              context,
                                              error,
                                              stackTrace,
                                            ) => const Center(
                                              child: Text(
                                                'Could not display the selected image.',
                                              ),
                                            ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text('No image selected'),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _PreviewPanel(
                              width: constraints.maxWidth,
                              height: useColumnLayout ? 800 : null,
                              title: 'Prediction',
                              child: _isPredicting
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : (_predictedBytes != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Image.memory(
                                              _predictedBytes!,
                                              fit: BoxFit.contain,
                                              gaplessPlayback: true,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Center(
                                                    child: Text(
                                                      'Could not display prediction',
                                                    ),
                                                  ),
                                            ),
                                          )
                                        : const Center(
                                            child: Text('No prediction yet'),
                                          )),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _PreviewPanel(
                              width: constraints.maxWidth / 2,
                              height : useColumnLayout ? 800 : null,
                              title: 'Selected image',
                              child: imageBytes != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.memory(
                                        imageBytes!,
                                        fit: BoxFit.contain,
                                        gaplessPlayback: true,
                                        errorBuilder:
                                            (
                                              context,
                                              error,
                                              stackTrace,
                                            ) => const Center(
                                              child: Text(
                                                'Could not display the selected image.',
                                              ),
                                            ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text('No image selected'),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PreviewPanel(
                              width: constraints.maxWidth / 2,
                              title: 'Prediction',
                              child: _isPredicting
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : (_predictedBytes != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Image.memory(
                                              _predictedBytes!,
                                              fit: BoxFit.contain,
                                              gaplessPlayback: true,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Center(
                                                    child: Text(
                                                      'Could not display prediction',
                                                    ),
                                                  ),
                                            ),
                                          )
                                        : const Center(
                                            child: Text('No prediction yet'),
                                          )),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  final double width;
  final String title;
  final Widget child;
  double? height;

  _PreviewPanel({
    required this.width,
    required this.title,
    required this.child,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 14),
            Expanded(
              child: SizedBox(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black.withOpacity(0.18)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
