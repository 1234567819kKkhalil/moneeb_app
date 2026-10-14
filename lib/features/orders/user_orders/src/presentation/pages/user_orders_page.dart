part of user_orders;

class UserOrdersPage extends StatelessWidget {
  const UserOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.appBackgroundColor,
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.ordersNav,
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => UserOrdersCubit(),
        child: const _UserOrdersTab(),
      ),
    );
  }
}

class _UserOrdersTab extends StatefulWidget {
  const _UserOrdersTab();

  @override
  State<_UserOrdersTab> createState() => _UserOrdersTabState();
}

class _UserOrdersTabState extends State<_UserOrdersTab>
    with FocusMonitorObserverMixin, NotificationActionsObserverMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(_onScroll);

    initFocusMonitor(myTabName: MainHostPageTabsEnum.orders, onFocus: getData);
    initNotificationActionsObserver(
      orderUpdated: (orderId, status) => getData(),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    await context.read<UserOrdersCubit>().fetchOrders();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final triggerExtent = _scrollController.position.maxScrollExtent * 0.2;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - triggerExtent) {
      context.read<UserOrdersCubit>().fetchMoreOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getData,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<UserOrdersCubit, UserOrdersCubitState>(
          builder: (context, state) {
            if (state.orders.isLoading || state.orders.isInitial) {
              return AppSkeletonizer(
                isEnabled: true,
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: Dimensions.bottomNavBarSafePadding(context),
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    return const UserOrderCard(
                      order: UserOrderEntity(
                        id: '',
                        serialNumber: '',
                        status: UserOrderStatus.pending,
                        beneficiaryType: BeneficiaryType.other,
                        beneficiaryName: '',
                        targetDate: null,
                        providerId: '',
                      ),
                    );
                  },
                ),
              );
            }

            if (state.orders.isFailure) {
              return Center(
                child: FailureWidget(
                  failure: state.orders.failure,
                  onRetryPressed: getData,
                ),
              );
            }

            final orders = state.orders.data ?? [];

            if (orders.isEmpty) {
              return Center(
                child: NoItemsFoundWidget(
                  text: appLocalizer.noOrdersMessage,
                  enableRefreshSupport: true,
                ),
              );
            }
            /* return ListView.separated(
              itemCount: 20,
              padding: EdgeInsets.only(
                top: 16,
                bottom: Dimensions.bottomNavBarSafePadding(context),
              ),
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                return Container(height: 100, color: Colors.grey.shade300);
              },
            ); */
            return ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.only(
                top: 0,
                bottom: Dimensions.bottomNavBarSafePadding(context),
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: orders.length + (state.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                if (index >= orders.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: AppProgressIndicator()),
                  );
                }
                return UserOrderCard(order: orders[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
