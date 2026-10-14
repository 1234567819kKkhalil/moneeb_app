part of helpers;

class _CancellableModel{
  String id;
  Completer<void>? completer;

  _CancellableModel({required this.id,required this.completer});
}

class CancellableOperation{
  final List<_CancellableModel> _completers = [];

  _CancellableModel _getCancellableModel(String id) {
    _CancellableModel? completerModel = _completers.firstWhereOrNull((element) => element.id == id);

    //Add if not exists
    if(completerModel == null){
      completerModel = _CancellableModel(id: id, completer: Completer<void>());
      _completers.add(completerModel);
    }

    return completerModel;
  }

  void cancel(String id) {
    final cancellableModel = _getCancellableModel(id);

    if (cancellableModel.completer != null && !cancellableModel.completer!.isCompleted) {
      cancellableModel.completer?.complete();
      cancellableModel.completer = null;
    }
  }

  Future<void> performOperation<T>({
    required String id,
    required FutureOr<T> Function() task,
    required FutureOr<void> Function(T) onCanOperateAfterTask,
  }) async {
    cancel(id);
    final innerScopeCompleter = Completer<void>();
    final cancellableModel = _getCancellableModel(id);

    cancellableModel.completer = innerScopeCompleter;

    final data = await task();

    if (!innerScopeCompleter.isCompleted) {
      await onCanOperateAfterTask(data);
    }

    if (cancellableModel.completer == innerScopeCompleter) {
      cancellableModel.completer = null;
    }
  }
}