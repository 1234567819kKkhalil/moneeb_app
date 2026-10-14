part of zad;

class ZadPage extends StatelessWidget {
  const ZadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ZadCubit()..init()),
        BlocProvider(
          create: (context) => injector<EventsCubit>()..fetchIslamicEvents(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  context.read<ZadCubit>().init(),
                  context.read<EventsCubit>().fetchIslamicEvents(),
                ]);
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: Dimensions.bottomNavBarSafePadding(context),
                ),
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        AppImage(
                          path: AssetPaths.zadBg,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 15,
                            decoration: BoxDecoration(
                              // gradient:
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  context.appColors.appBackgroundColor
                                      .withValues(alpha: 0.0),
                                  context.appColors.appBackgroundColor,
                                  // Colors.amber.withValues(alpha: 0.1),
                                  // Colors.amber,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          appLocalizer.zadNav,
                          style: context.bold.copyWith(fontSize: 28),
                        ),
                        /* Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          // Mocking CustomTextField for clean architecture migration
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 50,
                            decoration: BoxDecoration(
                              color: context.appColors.neutral.shade900,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  appLocalizer.searchHere,
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ), */
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appLocalizer.azkar,
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color:
                                            context.appColors.neutral.shade900,
                                      ),
                                ),
                              ),
                              /* GestureDetector(
                          onTap: () {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'المزيد',
                                style: context.theme.textTheme.bodyMedium
                                    ?.copyWith(
                                      color: context.appColors.neutral.shade900,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: 6),
                              // SvgPicture.asset(ZadConst.arrowMore)
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: context.appColors.secondary.shade500,
                              ),
                            ],
                          ),
                        ), */
                            ],
                          ),
                          BlocBuilder<ZadCubit, ZadState>(
                            builder: (context, state) {
                              return AppSkeletonizer(
                                isEnabled: state.azkarSections.isLoading,
                                child: GridView.builder(
                                  padding: EdgeInsets.only(
                                    top: 16,
                                    // bottom: 16,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.azkarSections.isLoading
                                      ? 4
                                      : (state.azkarSections.data?.length ??
                                                0) >
                                            4
                                      ? 4
                                      : (state.azkarSections.data?.length ?? 0),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 150 / 100,
                                        crossAxisCount: 2,
                                      ),
                                  itemBuilder: (context, index) {
                                    if (state.azkarSections.isLoading) {
                                      return AzkarZadItem(
                                        data: AzkarSectionModel.initial(),
                                      );
                                    }
                                    AzkarSectionModel data =
                                        state.azkarSections.data![index];
                                    return AzkarZadItem(data: data);
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appLocalizer.dua,
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color:
                                            context.appColors.neutral.shade900,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<ZadCubit, ZadState>(
                            builder: (context, state) {
                              return AppSkeletonizer(
                                isEnabled: state.duaList.isLoading,
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.duaList.isLoading
                                      ? 2
                                      : (state.duaList.data?.length ?? 0),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    final dua = state.duaList.isLoading
                                        ? DuaModel.initial()
                                        : state.duaList.data![index];

                                    return duaItem(dua, context, state);
                                  },
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appLocalizer.tasbeeh,
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color:
                                            context.appColors.neutral.shade900,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ZadItem(
                            image: ZadConst.imageZadSebha,
                            title: appLocalizer.tasbeeh,
                            description: appLocalizer.tasbeehDescription,
                            buttonText: appLocalizer.praiseNow,
                            iconPadding: 8,
                            iconColor: context.appColors.neutral.shade900,
                            onTap: () => AppRouteNavigator.push(
                              context,
                              TasbeehPage.routeName,
                              const TasbeehPage(),
                            ),
                            svgIcon: AssetPaths.iconTasbeeh,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appLocalizer.qiblah,
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color:
                                            context.appColors.neutral.shade900,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ZadItem(
                            image: AssetPaths.qiblaBg,
                            title: appLocalizer.qiblah,
                            description: appLocalizer.qiblahDescription,
                            buttonText: appLocalizer.qiblahNow,
                            onTap: () => AppRouteNavigator.push(
                              context,
                              QiblahPage.routeName,
                              const QiblahPage(),
                            ),
                            svgIcon: AssetPaths.iconCompass,
                          ),

                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appLocalizer.prayerTimes,
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color:
                                            context.appColors.neutral.shade900,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ZadItem(
                            image: AssetPaths.prayerTimesBg,
                            title: appLocalizer.prayerTimes,
                            description: appLocalizer.prayerTimesDescription,
                            buttonText: appLocalizer.time,
                            iconPadding: 8,
                            onTap: () => AppRouteNavigator.push(
                              context,
                              PrayerTimesPage.routeName,
                              const PrayerTimesPage(),
                            ),
                            svgIcon: AssetPaths.iconPrayerCurrent,
                          ),
                          /*   SizedBox(
                      child: Stack(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.network(
                              ZadConst.imageZadSalaa,
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 150,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(50),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 150,
                            padding: const EdgeInsets.all(8.0),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(50),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: context.appColors.primary.shade500,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'مواقيت الصلاة',
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        fontSize: 14,
                                        color:
                                            context.appColors.neutral.shade900,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          appLocalizer.prayerTimesDescription,
                                          maxLines: 3,
                                          style: context
                                              .theme
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                height: 1.7,
                                                fontSize: 10,
                                                color: context
                                                    .appColors
                                                    .neutral
                                                    .shade900,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: ZadActionButton(
                                    context: context,
                                    title: appLocalizer.time,
                                    onTap: () => AppRouteNavigator.push(
                                      context,
                                      PrayerTimesPage.routeName,
                                      const PrayerTimesPage(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                   */
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appLocalizer.occasions,
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color:
                                            context.appColors.neutral.shade900,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<EventsCubit, EventsState>(
                            builder: (context, state) {
                              if (state.events.isLoading) {
                                return const SizedBox(
                                  height: 180,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final events = state.events.data ?? [];
                              if (events.isEmpty)
                                return const SizedBox.shrink();

                              return SizedBox(
                                height: 150,
                                child: PageView.builder(
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    return OccasionZadItem(
                                      event: events[index],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          /* const SizedBox(height: 32), */
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget duaItem(DuaModel dua, BuildContext context, ZadState state) {
    return GestureDetector(
      onTap: () {
        if (!state.duaList.isLoading) {
          AppBottomSheets.showAppBottomSheet(
            context,
            useCloseButton: false,
            backgroundColor: context.appColors.primary.shade300,
            builder: (context) {
              return DuaContentBottomSheet(dua: dua);
            },
          );
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Stack(
          children: [
            AppImage(
              path: dua.fullImageUrl.isEmpty
                  ? ZadConst.imageZadDoaa
                  : dua.fullImageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
              borderRadius: BorderRadius.circular(16),
            ),

            Container(
              width: double.infinity,
              height: 150,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.all(8.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: context.appColors.primary.shade500,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AssetPaths.iconDoaaOutline,
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dua.localizedTitle,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: context.appColors.neutral.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            dua.localizedContent,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 10,
                              color: context.appColors.neutral.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ZadActionButton(
                  context: context,
                  title: appLocalizer.read,
                  onTap: () {
                    if (!state.duaList.isLoading) {
                      AppBottomSheets.showAppBottomSheet(
                        context,
                        useCloseButton: false,
                        backgroundColor: context.appColors.primary.shade300,
                        builder: (context) {
                          return DuaContentBottomSheet(dua: dua);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ZadItem extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String buttonText;
  final String? svgIcon;
  final double? iconPadding;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;

  const ZadItem({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
    this.iconPadding,
    this.icon,
    this.iconColor,
    this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Stack(
          children: [
            AppImage(
              path: image,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
              borderRadius: BorderRadius.circular(16),
            ),

            Container(
              width: double.infinity,
              height: 150,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.all(8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(iconPadding ?? 5),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: context.appColors.primary.shade500,
                      shape: BoxShape.circle,
                    ),
                    child: svgIcon != null
                        ? SvgPicture.asset(
                            svgIcon!,
                            width: 20,
                            height: 20,
                            colorFilter: iconColor == null
                                ? null
                                : ColorFilter.mode(iconColor!, BlendMode.srcIn),
                          )
                        : Icon(
                            icon,
                            size: 20,
                            color: context.appColors.neutral.shade900,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: context.appColors.neutral.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      description,
                      maxLines: 3,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        height: 1.7,
                        fontSize: 10,
                        color: context.appColors.neutral.shade900,
                      ),
                    ),
                  ),

                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ZadActionButton(
                      context: context,
                      title: buttonText,
                      onTap: onTap,
                    ),
                  ),
                ],
              ),
            ),
            /* GestureDetector(
              onTap: () => AppRouteNavigator.push(
                context,
                TasbeehPage.routeName,
                const TasbeehPage(),
              ),
              child: Container(
                // height: double.infinity,
                width: 100,
                color: Colors.amber.withAlpha(50),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}

class ZadActionButton extends StatelessWidget {
  const ZadActionButton({
    required this.context,
    required this.title,
    required this.onTap,
  });

  final BuildContext context;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.appColors.primary.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.neutral.shade900,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: context.appColors.neutral.shade900,
            ),
          ],
        ),
      ),
    );
  }
}
