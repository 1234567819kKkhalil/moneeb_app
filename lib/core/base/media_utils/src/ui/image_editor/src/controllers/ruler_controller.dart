part of image_editor;

class MyRulerController extends RulerPickerController {
  MyRulerController({num value = 0}) : _value = value;
  @override
  num get value => _value;
  num _value;
  @override
  set value(num newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  void setValueWithOutNotify(num newValue) {
    _value = newValue;
  }
}
