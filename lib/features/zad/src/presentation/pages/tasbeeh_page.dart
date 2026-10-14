part of zad;

class TasbeehPage extends StatelessWidget {
  static const String routeName = '/tasbeeh';

  const TasbeehPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<TasbeehCubit>()..fetchPresets(),
      child: Scaffold(
        appBar: AppBars.defaultBar(
          context,
          text: appLocalizer.tasbeeh,
          useCloseButton: true,
          centerTitle: true,
        ),
        body: const _TasbeehBody(),
      ),
    );
  }
}

class _TasbeehBody extends StatelessWidget {
  const _TasbeehBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasbeehCubit>();

    return SingleChildScrollView(
      // padding:
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                appLocalizer.selectDhikr,
                style: context.bold.copyWith(
                  color: context.appColors.neutral.shade900,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const Gap(18),
          const _DhikrPresets(),
          const Gap(18),
          const _DhikrInput(),
          const Gap(40),
          const _TasbeehCircle(),
          // const Gap(18),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  cubit.increment();
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 100,
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: AppPrimaryButton(
                      text: appLocalizer.resetSebha,
                      onPressed: cubit.reset,
                      textColor: context.appColors.neutral.shade900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DhikrPresets extends StatelessWidget {
  const _DhikrPresets();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbeehCubit, TasbeehState>(
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.presets.isLoading,
          // enabled: ,
          containersColor: context.appColors.primary.shade400,
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.presets.isLoading
                ? 6
                : (state.presets.data?.length ?? 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 14,
              childAspectRatio: 2.0,
            ),
            itemBuilder: (context, index) {
              if (state.presets.isLoading) {
                return _PresetItemPlaceholder();
              }
              final preset = state.presets.data![index];
              final isSelected = state.selectedIndex == index;

              return Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  GestureDetector(
                    onTap: () =>
                        context.read<TasbeehCubit>().selectPreset(index),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.appColors.primary.shade400,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: context.appColors.secondary.shade500,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          preset.localizedName,
                          style: context.bold.copyWith(
                            color: context.appColors.neutral.shade900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  /* AppPrimaryButton.outline(
                    onPressed: () =>
                        context.read<TasbeehCubit>().selectPreset(index),
                    padding: const EdgeInsets.all(4),
                    text: preset.arabicName,
                    textColor: context.appColors.neutral.shade50,
                    borderColor: isSelected
                        ? context.appColors.secondary.shade500
                        : context.appColors.secondary.shade300,
                  ), */
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        '${ZadConst.icons}icon_check1.svg',
                        width: 12,
                        height: 12,
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _PresetItemPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.secondary.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          appLocalizer.tasbeehPlaceholder,
          style: context.bold.copyWith(
            color: context.appColors.neutral.shade900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _DhikrInput extends StatefulWidget {
  const _DhikrInput();

  @override
  State<_DhikrInput> createState() => _DhikrInputState();
}

class _DhikrInputState extends State<_DhikrInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasbeehCubit, TasbeehState>(
      listenWhen: (prev, curr) =>
          curr.customDhikr.isEmpty && prev.customDhikr.isNotEmpty,
      listener: (context, state) {
        _controller.clear();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: AppSearchTextField(
          controller: _controller,
          searchHintText: appLocalizer.enterDhikr,
          requestNewSearchData: (value) {
            context.read<TasbeehCubit>().setCustomDhikr(value);
          },
          suffixIcon: SvgPicture.asset(
            AssetPaths.iconTasbeeh,
            // width: 12,
            // height: 12,
          ),
        ),
      ),
    );
  }
}

class _TasbeehCircle extends StatelessWidget {
  const _TasbeehCircle();

  final double size = 240;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbeehCubit, TasbeehState>(
      builder: (context, state) {
        final progress = state.progress.clamp(0.0, 1.0);
        final radius = size / 2;
        final angle = (2 * pi * progress) - pi / 2;
        final iconX = radius + radius * cos(angle);
        final iconY = radius + radius * sin(angle);

        String currentDhikr = '';
        if (state.customDhikr.isNotEmpty) {
          currentDhikr = state.customDhikr;
        } else if (state.presets.isSuccess &&
            state.presets.data != null &&
            state.selectedIndex != -1) {
          currentDhikr = state.presets.data![state.selectedIndex].localizedName;
        }

        return GestureDetector(
          onTap: () => context.read<TasbeehCubit>().increment(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () => context.read<TasbeehCubit>().increment(),
                child: Container(
                  height: size + 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
              SizedBox(
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
                        color: context.appColors.primary.shade400,
                        borderRadius: BorderRadius.circular(size / 2),
                      ),
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 4,
                        backgroundColor: context.appColors.secondary.shade500
                            .withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation(
                          context.appColors.secondary.shade500,
                        ),
                      ),
                    ),

                    // Moving icon
                    Positioned(
                      left: iconX - 8,
                      top: iconY - 8,
                      child: SvgPicture.asset(
                        '${ZadConst.icons}icon_tasbeeh_progess.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            currentDhikr,
                            textAlign: TextAlign.center,
                            style: context.medium.copyWith(
                              color: context.appColors.neutral.shade900,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          "${state.count}",
                          style: context.bold.copyWith(
                            color: context.appColors.neutral.shade900,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),

                    Positioned(
                      top: -24,
                      child: SvgPicture.asset(
                        '${ZadConst.icons}icon_time_sala_arrow.svg',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
