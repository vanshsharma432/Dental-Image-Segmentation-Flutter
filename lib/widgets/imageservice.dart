import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class PickedImageData {
  final Uint8List bytes;
  final String mimeType;

  const PickedImageData({required this.bytes, required this.mimeType});
}

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<PickedImageData?> pickImageForWeb() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo == null) {
      return null;
    }

    final Uint8List bytes = await photo.readAsBytes();
    return PickedImageData(
      bytes: bytes,
      mimeType: photo.mimeType ?? 'image/jpeg',
    );
  }

}