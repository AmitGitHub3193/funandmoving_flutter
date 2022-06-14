

import 'package:funandmoving/Models/QuestionModel.dart';

class SelectionModel{

  static final SelectionModel _instance = SelectionModel._internal();

  factory SelectionModel() {
    return _instance;
  }

  SelectionModel._internal();

  Selections videoClass=Selections();
  Selections exercise=Selections();
  Selections intensity=Selections();
}