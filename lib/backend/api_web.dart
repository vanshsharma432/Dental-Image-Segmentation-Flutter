import 'dart:typed_data';
import 'dart:html' as html;

final String apiUrl = "https://vansh-vs-sharma-dental.hf.space/api";
const String apiKey = "RonaldReaganWasHere\$\$\$432";

class Api {
  Future<bool> wakeUpServer() async {
    try {
      final req = await html.HttpRequest.request("$apiUrl/models", method: 'GET');
      return req.status == 200;
    } catch (e) {
      print('Error waking up server: $e');
      return false;
    }
  }

  Future<String> getModels() async {
    try {
      final req = await html.HttpRequest.request("$apiUrl/models", method: 'GET');
      if (req.status == 200) return req.responseText ?? '';
      return 'Error fetching models';
    } catch (e) {
      return 'Error fetching models';
    }
  }

  Future<Uint8List> predict(Uint8List imgdata, String model, bool face) async {
    final uri = face ? "$apiUrl/face/models/$model/predict" : "$apiUrl/models/$model/predict";
    try {
      final form = html.FormData();
      final blob = html.Blob([imgdata], 'application/octet-stream');
      form.appendBlob('file', blob, 'new.jpg');
      final req = await html.HttpRequest.request(
        uri,
        method: 'POST',
        sendData: form,
        requestHeaders: {'x-passkey': apiKey},
        responseType: 'arraybuffer',
      );
      if (req.status == 200) {
        final buffer = req.response as ByteBuffer;
        return Uint8List.view(buffer);
      }
      return Uint8List(0);
    } catch (e) {
      print('Prediction error (web): $e');
      return Uint8List(0);
    }
  }
}
