import 'dart:typed_data';

import 'package:http/http.dart' as http;

// For web builds provide the API key at compile time with --dart-define=API_KEY=your_key
const String apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
final String apiUrl = "https://vansh-vs-sharma-dental.hf.space/api";

class Api {
  String _incorrectPassKey() {
    print("Incorrect API Key. Please set the API_KEY environment variable.");
    return "";
  }

  Future<bool> wakeUpServer() async {
    try {
      // Probe a concrete API route instead of the base path.
      final Uri wakeupUri = Uri.parse("$apiUrl/models");
      final response = await http.get(wakeupUri).timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode == 200) {
        print('Server is awake!');
        return true;
      }

      print('Failed to wake up server. Status code: ${response.statusCode}');
      return false;
    } catch (e) {
      print('Error waking up server: $e');
      return false;
    }
  }

  Future<String> getModels() async {
    final uri = Uri.parse("$apiUrl/models");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("Error: ${response.statusCode}");
      return "Error fetching models";
    }
  }

  Future<Uint8List> predict(Uint8List imgdata, String model, bool face) async {
    final uri = face ? Uri.parse("$apiUrl/face/models/$model/predict") : Uri.parse("$apiUrl/models/$model/predict");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll({'x-passkey': apiKey.isEmpty ? _incorrectPassKey() : apiKey});
    request.files.add(
      http.MultipartFile.fromBytes('file', imgdata, filename: 'new.jpg'),
    );
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print(response.headers['content-type']);
      return response.bodyBytes;
    } else {
      print("Error: ${response.statusCode}");
      return Uint8List(0);
    }
  }
}