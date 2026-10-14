part of home;

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppLocalizations.of(context).stories,
                style: context.bold.copyWith(
                  color: context.appColors.neutral.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(16),

            // LOADING STATE: Use SingleChildScrollView + Row so Skeletonizer works
            if (state.storiesData.isLoading)
              AppSkeletonizer(
                isEnabled: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      10,
                      (index) =>
                          StoryHomeItem(provider: StoryProviderModel.initial()),
                    ),
                  ),
                ),
              )
            // FAILURE STATE: Show error + retry
            else if (state.storiesData.isFailure)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).unexpectedError,
                      style: context.regular.copyWith(color: Colors.grey[600]),
                    ),
                    const Gap(8),
                    InkWell(
                      onTap: () {
                        context.read<HomeCubit>().fetchStories();
                      },
                      child: Text(
                        AppLocalizations.of(context).retry,
                        style: context.regular.copyWith(
                          color: context.appColors.primary.shade500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            // EMPTY STATE: No stories available
            else if (state.storiesData.data == null ||
                state.storiesData.data!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 16,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).no_stories_available,
                    style: context.regular.copyWith(color: Colors.grey[600]),
                  ),
                ),
              )
            // SUCCESS STATE: Show stories with ListView.separated
            else
              SizedBox(
                height: 95,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: (state.storiesData.data!.length > 10)
                      ? 10
                      : state.storiesData.data!.length,
                  separatorBuilder: (context, index) => const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    return StoryHomeItem(
                      provider: state.storiesData.data![index],
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class StoryHomeItem extends StatelessWidget {
  final StoryProviderEntity? provider;

  const StoryHomeItem({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final storyPictureUrl = provider?.storyPictureUrl ?? '';

    return GestureDetector(
      onTap: () {
        if (provider == null || provider!.providerId.isEmpty) return;

        final homeCubit = context.read<HomeCubit>();
        final providers = homeCubit.state.storiesData.data ?? [];
        final index = providers.indexWhere(
          (element) => element.providerId == provider?.providerId,
        );

        AppRouteNavigator.pushTransparent(
          context,
          MultiBlocProvider(
            providers: [
              BlocProvider<HomeCubit>.value(value: homeCubit),
              BlocProvider<StoriesCubit>(
                create: (context) => injector<StoriesCubit>()
                  ..init(
                    providers: providers,
                    initialIndex: index == -1 ? 0 : index,
                    isGuest: context.read<AuthenticationBloc>().getUserRole == UserRoleEnum.guest,
                  ),
              ),
            ],
            child: const StoryViewerScreen(),
          ),
          routeName: StoryViewerScreen.routeName,
          rootNavigator: true,
          withDismissible: false,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: provider?.hasUnviewed ?? true
                      ? const Color(0xFFE6C27A)
                      : Colors.grey,
                  width: 2.5,
                ),
              ),
              child: ClipOval(
                child: storyPictureUrl.isNotEmpty
                    ? AppImage(
                        path: storyPictureUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: context.appColors.neutral.shade200,
                        child: Icon(
                          Icons.person,
                          color: context.appColors.neutral.shade400,
                          size: 32,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 64,
              child: Text(
                provider?.providerName.isNotEmpty ?? false
                    ? provider!.providerName
                    : appLocalizer.story,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  color: context.appColors.neutral.shade900,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
