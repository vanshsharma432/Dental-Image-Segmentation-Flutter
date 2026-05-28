import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class PickedImageData {
  final Uint8List bytes;

  const PickedImageData({required this.bytes});
}

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickImageForWeb() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo == null) {
      print("NULL IMAGE");
      return null;
    }
    final Uint8List bytes = await photo.readAsBytes();
    return bytes;
  }

}