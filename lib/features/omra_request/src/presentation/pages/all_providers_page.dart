part of omra_request;

class AllProvidersPage extends StatelessWidget {
  const AllProvidersPage({super.key});

  static const String routeName = 'AllProvidersPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBars.defaultBar(
        context,
        centerTitle: true,
        text: appLocalizer.pilgrims,
        useCloseButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PaginatedSearchView<ProviderEntity>(
          isLiveSearch: true,
          searchHintText: appLocalizer.searchHere,
          loadingItem: ProviderModel.initial(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          requestData: (searchTerm, pageKey) async {
            return await injector<GetProvidersUseCase>().execute(
              page: pageKey,
              search: searchTerm.trim().isEmpty ? null : searchTerm.trim(),
              isOnline: true,
            );
          },
          itemBuilder: (context, provider, index, itemsLength) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: UmrahPilgrimItem(
                provider: provider,
                onTap: () {
                  injector<OmraRequestCubit>().selectPilgrim(provider);
                  AppRouteNavigator.pop(context);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
