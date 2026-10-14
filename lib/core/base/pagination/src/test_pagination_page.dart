part of custom_pagination;

class TestPaginationPage extends StatefulWidget {
  const TestPaginationPage({super.key});

  @override
  State<TestPaginationPage> createState() => _TestPaginationPageState();
}

class _TestPaginationPageState extends State<TestPaginationPage> {
  final PaginationController<int, String> paginatedViewController = PaginationController<int, String>(initialPageKey: 1);
  final FlutterListViewController scrollController = FlutterListViewController();

  @override
  void initState() {

    paginatedViewController.addPageRequestListener((pageKey) async{
      await Future.delayed(const Duration(seconds: 2));
      paginatedViewController.appendPage(
        newItems: ['Item 1 => pageKey: ${paginatedViewController.state.pageKey}', 'Item 2 => pageKey: ${paginatedViewController.state.pageKey}', 'Item 3 => pageKey: ${paginatedViewController.state.pageKey}'],
        newKey: paginatedViewController.state.pageKey + 1,
        isLastPage: false
      );
    },);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async{
            paginatedViewController.refresh();
          },
          child: PositionedPaginatedListView<int, String>(
            controller: paginatedViewController,
            scrollController: scrollController,
            reversed: true,
            onItemKey: (index) => index.toString(),
            firstPageErrorBuilder: (context, failure) {
              return GestureDetector(
                onTap: () {
                  paginatedViewController.retryLastFailedRequest();
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("First page - ${failure.errorMessage}", style: TextStyle(fontSize: 18),),
                  ),
                ),
              );
            },
            firstPageLoadingBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
            newPageErrorBuilder: (context, failure) {
              return GestureDetector(
                onTap: () {
                  paginatedViewController.retryLastFailedRequest();
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(failure.errorMessage, style: TextStyle(fontSize: 18),),
                  ),
                ),
              );
            },
            newPageLoadingBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
            noItemsFoundBuilder: (context) {
              return const Center(child: Text('No items found'));
            },
            itemBuilder: (context,item, index){
              return Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(item, style: const TextStyle(fontSize: 24)),

                          GestureDetector(
                            onTap: (){
                              scrollController.animateTo(
                                0,
                                duration:Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: const Text("Animate to first index", style: TextStyle(fontSize: 24, color: Colors.green),
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              paginatedViewController.updateItem(
                                updateWhere: (e) => e == item,
                                newItem: (e)=> "IAM UPDATED"
                              );
                            },
                            child: const Text("Update me", style: TextStyle(fontSize: 24, color: Colors.blueAccent),
                            ),),

                          GestureDetector(
                            onTap: (){
                              paginatedViewController.removeItem(
                                (e) => e == item,
                              );
                            },
                            child: const Text("Delete me", style: TextStyle(fontSize: 24, color: Colors.red),
                            ),),

                          GestureDetector(
                            onTap: (){
                              paginatedViewController.addItem(
                                "ITEM ADDED"
                              );
                            },
                            child: const Text("Add item", style: TextStyle(fontSize: 24, color: Colors.red),
                            ),),

                          GestureDetector(
                            onTap: (){
                              paginatedViewController.addItem(
                                  "ITEM INSERTED",
                                atIndex: 0
                              );
                            },
                            child: const Text("INSERT item", style: TextStyle(fontSize: 24, color: Colors.red),
                            ),),

                          GestureDetector(
                            onTap: (){
                              paginatedViewController.setError(UnExpectedFailure('failed to load items'));
                            },
                            child: const Text("Fail next request", style: TextStyle(fontSize: 24, color: Colors.red),
                            ),
                          ),

                        ],
                      ),
                    )
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}