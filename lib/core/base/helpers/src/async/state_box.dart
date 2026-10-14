part of helpers;

enum StateType{
  initial, loading, success, failure
}

class StateBox<T> extends Equatable{
  final StateType type;
  final T? data;
  final Failure? failure;

  const StateBox({
    required this.type,
    this.data,
    this.failure,
  });

  bool get isFailure => type == StateType.failure;
  bool get isSuccess => type == StateType.success;
  bool get isInitial => type == StateType.initial;
  bool get isLoading => type == StateType.loading;

  const StateBox.initial() : this(type: StateType.initial);
  const StateBox.loading() : this(type: StateType.loading);
  const StateBox.success(T data) : this(type: StateType.success, data: data);
  const StateBox.successWithoutData() : this(type: StateType.success);
  const StateBox.failure(Failure failure) : this(type: StateType.failure, failure: failure);

  void when({
    void Function()? initial,
    void Function()? loading,
    void Function(T? data)? success,
    void Function(Failure failure)? error,
  }){
    switch(type){
      case StateType.initial:
        initial?.call();
        break;
      case StateType.loading:
        loading?.call();
        break;
      case StateType.success:
        success?.call(data);
        break;
      case StateType.failure:
        error?.call(failure!);
        break;
    }
  }

  @override
  List<Object?> get props => [type, data, failure];
}
