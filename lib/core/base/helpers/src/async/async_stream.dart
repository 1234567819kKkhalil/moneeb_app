part of helpers;

typedef OperationBlock<T> = Future<T> Function(
    StreamController<OperationProgress> receiveProgress);

class OperationProgress {
  final int count;
  final int total;

  OperationProgress(this.count, this.total);

  OperationProgress.initial() : this(0, 0);

  double get percent {
    return count.toDouble() / total;
  }
}

class AsyncStream<T> {

  final OperationBlock<T> _operation;
  final StreamController<OperationProgress> _streamController;

  Stream<OperationProgress> get receiveProgress => _streamController.stream;

  Future<T> get result => _operation(_streamController);

  AsyncStream(this._operation,
      {StreamController<OperationProgress>? streamController})
      : _streamController =
            streamController ?? StreamController<OperationProgress>();

  void onClose() {
    // injector.get<Dio>(instanceName: "download").close();
    _streamController.close();
  }

  AsyncStream<NewType> map<NewType>(
      Future<NewType> Function(T resultValue) block) {
    return AsyncStream<NewType>(
      (receiveProgress) {
        return _operation(receiveProgress).then((value) => block(value));
      },
      streamController: _streamController,
    );
  }

}
