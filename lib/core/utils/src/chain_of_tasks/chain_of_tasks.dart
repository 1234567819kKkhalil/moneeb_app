part of app_utils;

typedef ChainTaskFunction<T> = Future<T> Function(T input);
typedef ConsumerFunction<T> = Future<bool> Function(T input);

class ChainOfTasks {
  ChainOfTasks._();

  static Future<T> chain<T>(T input, List<ChainTaskFunction<T>> tasks) async {
    return tasks.fold(
      Future.value(input),
      (previousValue, task) async => task(await previousValue),
    );
  }

  static Future<void> consumeFirst<T>(
      T input, List<ConsumerFunction<T>> tasks) async {
    for (final task in tasks) {
      final handled = await task(input);
      if (handled) {
        return;
      }
    }
  }
}