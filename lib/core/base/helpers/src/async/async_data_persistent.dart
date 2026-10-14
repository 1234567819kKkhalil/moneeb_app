part of helpers;

class AsyncDataPersistent<T> extends Equatable {
  final T? data;
  final Failure? error;
  final bool _successWithoutData;
  final bool? _loading;

  const AsyncDataPersistent._(
      this.data, this.error, this._successWithoutData, this._loading);

  bool get isLoading => _loading ?? false;

  bool get isSuccess =>
      (_successWithoutData || data != null) && (error == null);

  bool get isFailure => error != null;

  bool get isInitial => (data == null)
      && (error == null)
      && (_successWithoutData == false)
      && (_loading == null);

  AsyncDataPersistent<T> loading() => AsyncDataPersistent<T>._(data, null, false, true);
  AsyncDataPersistent<T> success(T data) => AsyncDataPersistent<T>._(data, null, false, false);
  AsyncDataPersistent<T> failure(Failure error, {bool resetData = false}) => AsyncDataPersistent<T>._(resetData ? null :data, error, false, false);

  const AsyncDataPersistent.successWithoutData(): this._(null, null, true, false);
  const AsyncDataPersistent.initial() : this._(null, null, false, null);

  @override
  List<Object?> get props =>
      [data, error, _successWithoutData, _loading];
}
