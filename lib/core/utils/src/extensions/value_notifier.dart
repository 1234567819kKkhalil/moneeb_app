part of app_utils;

class ListValueNotifier<T> extends ValueNotifier<List<T>> {
  ListValueNotifier(super.value);

  /// [process] add or remove item
  void process(T newValue) {
    if (value.contains(newValue)) {
      _remove(newValue);
    } else {
      _add(newValue);
    }
  }

  void _add(T valueToAdd) => value = [...value, valueToAdd];

  void _remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }
}
