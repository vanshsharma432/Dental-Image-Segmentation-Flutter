import 'package:flutter/material.dart';

class ModelProvider extends ChangeNotifier{
  String model = "yolov8s";
  void setModel(String newModel){
    model = newModel;
    notifyListeners();
  }
  String getModel(){
    return model;
  }
}
class MouthModelProvider extends ChangeNotifier{
  bool face = false;
  void setFace(){
    face = true;
    notifyListeners();
  }
  void setMouth(){
    face = false;
    notifyListeners();
  }
  bool getFace(){
    return face;
  }
}