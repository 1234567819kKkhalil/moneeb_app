part of zad;

class PrayerTimesPage extends StatelessWidget {
  static const String routeName = '/prayer-times';

  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<PrayerTimesCubit>()..fetchPrayerTimes(),
      child: Scaffold(
        appBar: AppBars.defaultBar(
          context,
          text: appLocalizer.timings,
          useCloseButton: true,
          centerTitle: true,
        ),
        body: const _PrayerTimesBody(),
      ),
    );
  }
}

class _PrayerTimesBody extends StatelessWidget {
  const _PrayerTimesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        if (state.prayerData.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: context.appColors.secondary.shade500,
            ),
          );
        }

        if (state.prayerData.isFailure) {
          return Center(
            child: Text(
              state.prayerData.failure?.errorMessage ??
                  appLocalizer.somethingWentWrong,
              style: context.regular.copyWith(
                color: context.appColors.neutral.shade50,
              ),
            ),
          );
        }

        if (!state.prayerData.isSuccess || state.prayerData.data == null) {
          return const SizedBox.shrink();
        }

        final data = state.prayerData.data!;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Gap(18),
              const _PrayerCircle(),
              const Gap(40),
              Text(
                appLocalizer.today,
                style: context.medium.copyWith(
                  color: context.appColors.neutral.shade900,
                  fontSize: 10,
                ),
              ),
              const Gap(12),
              _DateInfo(hijri: data.date.hijri),
              const Gap(20),
              _PrayerList(timings: data.timings, result: state.result),
              const Gap(40),
            ],
          ),
        );
      },
    );
  }
}

class _PrayerCircle extends StatelessWidget {
  const _PrayerCircle();

  final double size = 260;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        final progress = state.result.progress;
        final radius = size / 2;
        final angle = (2 * pi * progress) - pi / 2;

        final iconX = radius + radius * cos(angle);
        final iconY = radius + radius * sin(angle);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size / 2),
                ),
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: context.appColors.primary.shade800
                      .withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation(
                    context.appColors.secondary.shade500,
                  ),
                ),
              ),

              // Moving icon
              Positioned(
                left: iconX - 8,
                top: iconY - 18,
                child: SvgPicture.asset(
                  '${ZadConst.icons}icon_prayer_time.svg',
                  width: 16,
                  height: 16,
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.result.current,
                    textAlign: TextAlign.center,
                    style: context.bold.copyWith(
                      color: context.appColors.neutral.shade500,
                      fontSize: 20,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    appLocalizer.remaining,
                    style: context.bold.copyWith(
                      color: context.appColors.neutral.shade900,
                      fontSize: 10,
                    ),
                  ),
                  const Gap(14),
                  Text(
                    context.read<PrayerTimesCubit>().formatDuration(
                      state.result.remaining,
                    ),
                    style: context.bold.copyWith(
                      color: context.appColors.neutral.shade500,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DateInfo extends StatelessWidget {
  final HijriDate hijri;

  const _DateInfo({required this.hijri});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(
                color: context.appColors.secondary.shade400.withOpacity(0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${hijri.arabicWeekday} , ${hijri.arabicMonth} , ${hijri.date} هـ',
                style: context.medium.copyWith(
                  color: context.appColors.secondary.shade400,
                  fontSize: 10,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: context.appColors.secondary.shade400.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PrayerList extends StatelessWidget {
  final Timings timings;
  final PrayerResult result;

  const _PrayerList({required this.timings, required this.result});

  @override
  Widget build(BuildContext context) {
    final prayers = timings.toList();

    return Column(
      children: prayers
          .map(
            (p) => _PrayerItem(
              name: p.key,
              // Backend sends 24-hour "HH:mm" — render it in the app's format.
              time: AppTimeFormat.apiTime(p.value),
              isCurrent: p.key == result.current,
              isNext: p.key == result.next,
            ),
          )
          .toList(),
    );
  }
}

class _PrayerItem extends StatelessWidget {
  final String name;
  final String time;
  final bool isCurrent;
  final bool isNext;

  const _PrayerItem({
    required this.name,
    required this.time,
    required this.isCurrent,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (isCurrent) {
      bgColor = context.appColors.primary.shade400;
      textColor = context.appColors.neutral.shade900;
    } else if (isNext) {
      bgColor = context.appColors.neutral.shade300.withOpacity(0.1);
      textColor = context.appColors.neutral.shade900;
    } else {
      bgColor = context.appColors.neutral.shade300.withOpacity(0.1);
      textColor = context.appColors.neutral.shade900;
    }

    String iconName;
    if (isCurrent) {
      iconName = 'icon_prayer_current.svg';
    } else if (isNext) {
      iconName = 'icon_prayer_coming.svg';
    } else {
      iconName = 'icon_prayer_missed.svg';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: /* isCurrent || */ isNext
            ? Border.all(color: context.appColors.neutral.shade900, width: 1)
            : null,
      ),
      child: Row(
        children: [
          SvgPicture.asset('${ZadConst.icons}$iconName'),
          const Gap(12),
          Expanded(
            child: Text(
              name,
              style: context.medium.copyWith(color: textColor, fontSize: 15),
            ),
          ),
          Text(
            time,
            style: context.medium.copyWith(color: textColor, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
