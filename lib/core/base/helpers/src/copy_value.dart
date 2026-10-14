class CopyValue<T>{
  final T? _value;
  final bool acceptNull;

  const CopyValue.nullable(T? value) : acceptNull = true, _value = value;
  const CopyValue.set(T? value) : acceptNull = false, _value = value;

  T? resolve(T? currentVal){
    if(acceptNull){
      return _value;
    } else {
      return _value ?? currentVal;
    }
  }
}