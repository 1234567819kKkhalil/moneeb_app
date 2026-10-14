part of provider_orders;

class ProviderOrdersPage extends StatelessWidget {
  const ProviderOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderActionsCubit()),
        BlocProvider(create: (_) => ProviderOrdersCubit()),
      ],
      child: const _ProviderOrdersBody(),
    );
  }
}

class _ProviderOrdersBody extends StatefulWidget {
  const _ProviderOrdersBody();

  @override
  State<_ProviderOrdersBody> createState() => _ProviderOrdersBodyState();
}

class _ProviderOrdersBodyState extends State<_ProviderOrdersBody>
    with OmrahObserverMixin {
  static const double _loadMoreTriggerFraction = 0.2;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    initOmrahObserver(omrahCompleted: (orderId) => _refresh());

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() => context.read<ProviderOrdersCubit>().fetchOrders();

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final triggerExtent = position.maxScrollExtent * _loadMoreTriggerFraction;
    if (position.pixels >= position.maxScrollExtent - triggerExtent) {
      context.read<ProviderOrdersCubit>().fetchMoreOrders();
    }
  }

  void _onActionsStateChanged(
    BuildContext context,
    ProviderActionsState state,
  ) {
    if (state.acceptState.isSuccess) {
      _refresh();

      final omrahData = state.acceptState.data;
      if (omrahData != null) {
        // if the user already in omrah, do not show the new one
        FloatingOmrahOverlayManager.showOverlay(context, stepper: omrahData);
      }
    } else if (state.rejectState.isSuccess) {
      _refresh();
    } else if (state.cancelState.isSuccess) {
      _refresh();
    } else if (state.completeState.isSuccess) {
      _refresh();
    }

    final failure =
        state.acceptState.failure ??
        state.rejectState.failure ??
        state.cancelState.failure ??
        state.completeState.failure;
    if (failure != null) {
      AppToasts.error(context, message: failure.errorMessage ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.ordersNav,
        centerTitle: true,
        showDivider: false,
      ),
      body: BlocListener<ProviderActionsCubit, ProviderActionsState>(
        listener: _onActionsStateChanged,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: BlocBuilder<ProviderOrdersCubit, ProviderOrdersState>(
                    builder: _buildOrdersList,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, ProviderOrdersState state) {
    if (state.orders.isLoading || state.orders.isInitial) {
      return const Center(child: CustomAnimationLoading());
    }

    if (state.orders.isFailure) {
      return Center(
        child: FailureWidget(
          failure: state.orders.failure,
          onRetryPressed: _refresh,
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

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.only(
        top: 0,
        bottom: Dimensions.bottomNavBarSafePadding(context),
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: orders.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        if (index >= orders.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: AppProgressIndicator()),
          );
        }
        return ProviderOrderCard(order: orders[index]);
      },
    );
  }
}
