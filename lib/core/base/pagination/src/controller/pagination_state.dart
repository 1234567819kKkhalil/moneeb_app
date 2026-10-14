part of custom_pagination;

class PaginationState<K, T> extends Equatable {
  final K pageKey;
  final bool isLastPage;
  final bool isLoading;
  final Failure? failure;
  final List<T> items;

  const PaginationState({
    required this.pageKey,
    required this.isLastPage,
    required this.isLoading,
    required this.failure,
    required this.items,
  });

  PaginationState.initial({required K initialKey, bool autoFetch = true})
      : this(
    isLoading: autoFetch,
    isLastPage: false,
    items: [],
    pageKey: initialKey,
    failure: null,
  );

  PaginationState<K, T> copyWith({
    K? pageKey,
    bool? isLastPage,
    bool? isLoading,
    Failure? failure,
    List<T>? items,
  }) {
    return PaginationState<K, T>(
      pageKey: pageKey ?? this.pageKey,
      isLastPage: isLastPage ?? this.isLastPage,
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    pageKey,
    isLastPage,
    isLoading,
    failure,
    items,
  ];
}
