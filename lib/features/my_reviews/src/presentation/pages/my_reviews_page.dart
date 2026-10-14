part of my_reviews;

class MyReviewsPage extends StatefulWidget {
  static const String routeName = '/my-reviews';

  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.appBackgroundColor,
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.my_rate_settings,
        useCloseButton: true,
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => injector<MyReviewsCubit>()..fetchReviews(),
        child: const _MyReviewsBody(),
      ),
    );
  }
}

class _MyReviewsBody extends StatelessWidget {
  const _MyReviewsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyReviewsCubit, MyReviewsState>(
      builder: (context, state) {
        if (state.reviews.isFailure) {
          return FailureWidget(
            failure: state.reviews.failure,
            onRetryPressed: () {
              context.read<MyReviewsCubit>().fetchReviews();
            },
          );
        }

        if (state.reviews.isSuccess && (state.reviews.data?.isEmpty ?? true)) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: NoItemsFoundWidget(
              text: appLocalizer.noReviewsYet,
              enableRefreshSupport: false,
            ),
          );
        }

        return AppSkeletonizer(
          isEnabled: state.reviews.isLoading || state.reviews.isInitial,
          child: ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: state.reviews.isLoading || state.reviews.isInitial
                ? 3
                : (state.reviews.data?.length ?? 0),
            itemBuilder: (context, index) {
              final review = state.reviews.isLoading || state.reviews.isInitial
                  ? MyReviewModel.initial()
                  : state.reviews.data![index];
              return MyReviewItemWidget(review: review);
            },
          ),
        );
      },
    );
  }
}
