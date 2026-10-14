part of app_utils;

class RandomId{
  RandomId._();

  static int _i = 0;

  static String generate(){
    return '${++_i}';
  }

  static int generateInt(){
    return ++_i;
  }

  static String generateUnique(){
    return generate() + DateTime.now().millisecondsSinceEpoch.toString();
  }

  static int generateUniqueInt(){
    return generateInt() + DateTime.now().millisecondsSinceEpoch;
  }
}