part of zad;

class EventsPage extends StatelessWidget {
  static const String routeName = '/events';

  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<EventsCubit>()..fetchIslamicEvents(),
      child: Scaffold(
        appBar: AppBars.defaultBar(
          context,
          text: appLocalizer.occasions,
          useCloseButton: true,
          centerTitle: true,
        ),
        body: const _EventsBody(),
      ),
    );
  }
}

List<EventModel> _placeholderEvents() {
  return List.generate(
    5,
    (index) => EventModel(
      id: 'placeholder_$index',
      name: 'جاري التحميل...',
      date: DateTime.now().toIso8601String(),
      daysRemaining: 10,
    ),
  );
}

String _eventHijriDate(BuildContext context, String isoDate) {
  final date = DateTime.tryParse(isoDate);
  if (date == null) return isoDate;

  final langCode = AppLanguageCubit.of(
    context,
  ).localizationContainer.langCode.name;
  final hijri = HijriCalendar.fromDate(date);

  return langCode == 'ar'
      ? '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} هـ'
      : '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} AH';
}

class _EventsBody extends StatelessWidget {
  const _EventsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        if (state.events.isFailure) {
          return Center(
            child: Text(
              state.events.failure?.errorMessage ??
                  appLocalizer.somethingWentWrong,
              style: context.regular.copyWith(
                color: context.appColors.neutral.shade900,
              ),
            ),
          );
        }

        final isLoading = state.events.isLoading || state.events.isInitial;
        final events = isLoading
            ? _placeholderEvents()
            : (state.events.data ?? const <EventModel>[]);

        if (!isLoading && events.isEmpty) {
          return _EmptyEvents(message: appLocalizer.noItemFoundError);
        }

        final featuredEvent = events.first;
        final restEvents = events.skip(1).toList();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Gap(18),
              Text(
                appLocalizer.today,
                style: context.bold.copyWith(
                  color: context.appColors.neutral.shade900,
                  fontSize: 10,
                ),
              ),
              const Gap(14),
              const _TodayInfo(),
              const Gap(22),
              AppSkeletonizer(
                isEnabled: isLoading,
                child: Column(
                  children: [
                    _FeaturedEventCard(event: featuredEvent),
                    if (restEvents.isNotEmpty) ...[
                      const Gap(16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: restEvents.length,
                        itemBuilder: (context, index) {
                          return _EventListItem(event: restEvents[index]);
                        },
                        separatorBuilder: (context, index) {
                          return const Gap(12);
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(40),
            ],
          ),
        );
      },
    );
  }
}

class _TodayInfo extends StatelessWidget {
  const _TodayInfo();

  @override
  Widget build(BuildContext context) {
    // Current date in Arabic format
    final now = DateTime.now();
    final formatter = DateFormat(
      'EEEE , d MMMM y',
      AppLanguageCubit.of(context).localizationContainer.langCode.name,
    );
    final formattedDate = formatter.format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: context.appColors.secondary.shade500.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            formattedDate,
            style: context.regular.copyWith(
              color: context.appColors.secondary.shade500,
              fontSize: 10,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: context.appColors.secondary.shade500.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}

/// Highlighted card for the nearest upcoming event.
class _FeaturedEventCard extends StatelessWidget {
  final EventModel event;

  const _FeaturedEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final hijriDate = _eventHijriDate(context, event.date);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            context.appColors.primary.shade400,
            context.appColors.primary.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.appColors.secondary.shade500.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: context.appColors.secondary.shade500.withOpacity(0.2),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            // padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  context.appColors.secondary.shade400,
                  context.appColors.secondary.shade700,
                ],
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: AppImage(
              path: event.imageUrl?.addBaseUrl ?? '',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorPlaceHolder: () => ColoredBox(
                color: context.appColors.backgroundColorForProviderCard,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    AssetPaths.moneebLogo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.bold.copyWith(
                    color: context.appColors.neutral.shade900,
                    fontSize: 14,
                  ),
                ),
                // const Gap(6),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    gradient: LinearGradient(
                      colors: [
                        context.appColors.secondary.shade900,
                        context.appColors.secondary.shade500,
                      ],
                    ),
                    color: context.appColors.secondary.shade400,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: context.appColors.neutral.shade900.withOpacity(
                        0.55,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      hijriDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.regular.copyWith(
                        color: context.appColors.neutral.shade900.withOpacity(
                          0.55,
                        ),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              // color: context.appColors.secondary.shade500.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (event.daysRemaining > 0)
                  Text(
                    appLocalizer.remaining,
                    style: context.bold.copyWith(
                      color: context.appColors.secondary.shade500,
                      fontSize: 9,
                    ),
                  ),
                Gap(2),
                Text(
                  '${event.daysRemaining}',
                  style: context.bold.copyWith(
                    color: context.appColors.secondary.shade400,
                    fontSize: 18,
                    height: 1.3,
                  ),
                ),
                Text(
                  appLocalizer.days,
                  style: context.regular.copyWith(
                    color: context.appColors.neutral.shade900.withOpacity(0.55),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),

          /* Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (event.daysRemaining > 0)
                Text(
                  appLocalizer.remaining,
                  style: context.bold.copyWith(
                    color: context.appColors.secondary.shade500,
                    fontSize: 11,
                  ),
                ),
              const Gap(4),
              Text(
                '${event.daysRemaining}',
                style: context.bold.copyWith(
                  color: context.appColors.secondary.shade400,
                  fontSize: 30,
                  height: 1,
                ),
              ),
              const Gap(2),
              Text(
                appLocalizer.days,
                style: context.regular.copyWith(
                  color: context.appColors.neutral.shade900.withOpacity(0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ), */
        ],
      ),
    );
  }
}

/// Compact row for the rest of the events list.
class _EventListItem extends StatelessWidget {
  final EventModel event;

  const _EventListItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final hijriDate = _eventHijriDate(context, event.date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      decoration: BoxDecoration(
        color: context.appColors.primary.shade400,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.appColors.secondary.shade500.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppImage(
              path: event.imageUrl?.addBaseUrl ?? '',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorPlaceHolder: () => ColoredBox(
                color: context.appColors.backgroundColorForProviderCard,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    AssetPaths.moneebLogo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bold.copyWith(
                    color: context.appColors.neutral.shade900,
                    fontSize: 14,
                  ),
                ),
                // const Gap(6),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    gradient: LinearGradient(
                      colors: [
                        context.appColors.secondary.shade900,
                        context.appColors.secondary.shade500,
                      ],
                    ),
                    color: context.appColors.secondary.shade400,
                  ),
                ),
                // const Gap(6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: context.appColors.neutral.shade900.withOpacity(
                        0.5,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      hijriDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.regular.copyWith(
                        color: context.appColors.neutral.shade900.withOpacity(
                          0.5,
                        ),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              // color: context.appColors.secondary.shade500.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (event.daysRemaining > 0)
                  Text(
                    appLocalizer.remaining,
                    style: context.bold.copyWith(
                      color: context.appColors.secondary.shade500,
                      fontSize: 9,
                    ),
                  ),
                Gap(2),
                Text(
                  '${event.daysRemaining}',
                  style: context.bold.copyWith(
                    color: context.appColors.secondary.shade400,
                    fontSize: 18,
                    height: 1.3,
                  ),
                ),
                Text(
                  appLocalizer.days,
                  style: context.regular.copyWith(
                    color: context.appColors.neutral.shade900.withOpacity(0.55),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyEvents extends StatelessWidget {
  final String message;

  const _EmptyEvents({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_note_rounded,
              size: 56,
              color: context.appColors.neutral.shade400,
            ),
            const Gap(12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.regular.copyWith(
                color: context.appColors.neutral.shade700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
