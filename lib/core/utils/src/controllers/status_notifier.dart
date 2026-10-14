part of app_utils;

class StatusNotifier extends ChangeNotifier implements ValueListenable<bool> {
  final bool Function() _checkCallback;
  late bool _lastValue;

  StatusNotifier(this._checkCallback) {
    _lastValue = _checkCallback();
  }

  @override
  bool get value => _lastValue;

  void check() {
    final currentValue = _checkCallback();

    if (_lastValue != currentValue) {
      _lastValue = currentValue;
      notifyListeners();
    }
  }
}
