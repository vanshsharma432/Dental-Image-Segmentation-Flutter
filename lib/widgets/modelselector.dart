import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/providers.dart';

class Modelselector extends StatefulWidget {
  const Modelselector({super.key});

  @override
  State<Modelselector> createState() => _ModelselectorState();
}

class _ModelselectorState extends State<Modelselector> {
  final Map<String, String> models = {
    "U-Net": "unet",
    "U-Net Enhanced": "unet-enhanced",
    "DeepLabv3": "deeplabv3",
    "YOLOv8 Small": "yolov8s",
    "YOLOv8 Large": "yolov8l",
    "YOLO11 Small": "yolo11s",
    "YOLO11 Large": "yolo11l",
  };

  String? selectedModel;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        visualDensity: VisualDensity(horizontal: 0),
        padding: WidgetStatePropertyAll(const EdgeInsets.symmetric(horizontal: 4, vertical: 4)),        
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
        ),
      ),
      enableSearch: true,
      enableFilter: true,
      width: 260,
      hintText: 'Select model',
      initialSelection: context.watch<ModelProvider>().getModel(),
      onSelected: (value) {
        setState(() {
          selectedModel = value;
          Provider.of<ModelProvider>(context, listen: false).setModel(value!);
        });
      },
      textStyle: Theme.of(context).textTheme.bodyMedium,
      dropdownMenuEntries: models.entries
          .map(
            (entry) =>
                DropdownMenuEntry<String>(value: entry.value, label: entry.key),
          )
          .toList(),
    );
  }
}
