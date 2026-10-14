// ignore_for_file: library_private_types_in_public_api

part of nested_paginated_list;

typedef _ItemWidgetBuilder<ItemType> = Widget Function(
   BuildContext context,
   int index,
   ItemType item,
   NestedPaginatedItemEntity<ItemType> itemDetails,
);

typedef _LoaderWidgetBuilder<ItemType> = Widget Function(
  BuildContext context,
  PaginationDirectionEnum direction,
  void Function() retryFunction,
);

class NestedPaginatedListDelegate<ItemType> {
  final _ItemWidgetBuilder<ItemType> itemBuilder;
  final WidgetBuilder? firstPageLoaderBuilder;
  final WidgetBuilder? firstPageErrorBuilder;
  final WidgetBuilder? noDataFoundBuilder;
  final Widget Function(
    BuildContext context,
    PaginationDirectionEnum direction,
  )? loadMoreBuilder;
  final _LoaderWidgetBuilder? failLoadMoreBuilder;
  final WidgetBuilder? refreshInductorWidget;

  NestedPaginatedListDelegate({
    required this.itemBuilder,
    this.firstPageLoaderBuilder,
    this.firstPageErrorBuilder,
    this.noDataFoundBuilder,
    this.loadMoreBuilder,
    this.failLoadMoreBuilder,
    this.refreshInductorWidget,
  });
}

class DefaultFirstPageLoaderBuilder extends StatelessWidget {
  const DefaultFirstPageLoaderBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('First Page Loading ...'));
  }
}

class _DefaultFirstPageErrorBuilder extends StatelessWidget {
  const _DefaultFirstPageErrorBuilder({this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed To Load First Page',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.refresh,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}

class _DefaultNoDataFoundBuilder extends StatelessWidget {
  const _DefaultNoDataFoundBuilder();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No Data Found...'));
  }
}
