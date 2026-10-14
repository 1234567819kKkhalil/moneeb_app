part of auth;

/// The charter's whole palette: two brand accents and nothing else.
///
/// [ink] and [gold] are the static brand values rather than `context.appColors`
/// shades, because both are only ever used as a *filled surface* (or as an
/// ornament on one) — never as text on the page background. That keeps them
/// identical in light and dark mode, while every piece of text on the page
/// stays on the theme's neutral ramp, which inverts correctly.
class _CharterPalette {
  _CharterPalette._();

  static const Color ink = AppColors.primary500;
  static const Color gold = AppColors.secondary900;
  static const Color onInk = AppColors.neutral50;
}

/// One numbered clause of the charter: a title, a short lead-in line and the
/// undertakings it contains.
class _CharterSection {
  final String title;
  final String intro;
  final List<String> items;

  const _CharterSection({
    required this.title,
    required this.intro,
    required this.items,
  });
}

class ProviderKasamPage extends StatefulWidget {
  const ProviderKasamPage({super.key});

  static const String routeName = "ProviderKasamPage";

  @override
  State<ProviderKasamPage> createState() => _ProviderKasamPageState();
}

class _ProviderKasamPageState extends State<ProviderKasamPage> {
  final ScrollController _scrollController = ScrollController();

  /// How much of the charter has scrolled past, 0..1 — drives the bar under
  /// the app bar so the reader can see how much is left.
  double _readProgress = 0;

  /// The charter has been shown to its end. The acknowledgement stays hidden
  /// until this is true, so nobody can swear to text they never saw.
  bool _reachedEnd = false;

  bool _isAgree = false;

  bool get _canSubmit => _reachedEnd && _isAgree;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // A short charter (large screen / small text scale) never scrolls, so the
    // reader would otherwise be locked out of a document already fully visible.
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final maxExtent = position.maxScrollExtent;

    final double progress = maxExtent <= 0
        ? 1
        : (position.pixels / maxExtent).clamp(0.0, 1.0);
    final bool reachedEnd = maxExtent <= 0 || position.pixels >= maxExtent - 24;

    if (progress == _readProgress && (_reachedEnd || !reachedEnd)) return;

    // Unlocking is the one moment on this page worth feeling.
    if (reachedEnd && !_reachedEnd) HapticFeedback.lightImpact();

    setState(() {
      _readProgress = progress;
      // Never revoke it: once read, scrolling back up stays allowed.
      _reachedEnd = _reachedEnd || reachedEnd;
    });
  }

  void _jumpToEnd() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _submit() {
    if (!_canSubmit) return;
    AppRouteNavigator.pop(context);
  }

  List<_CharterSection> _sections() => [
    _CharterSection(
      title: appLocalizer.charterS1Title,
      intro: appLocalizer.charterS1Intro,
      items: [
        appLocalizer.charterS1I1,
        appLocalizer.charterS1I2,
        appLocalizer.charterS1I3,
        appLocalizer.charterS1I4,
        appLocalizer.charterS1I5,
        appLocalizer.charterS1I6,
      ],
    ),
    _CharterSection(
      title: appLocalizer.charterS2Title,
      intro: appLocalizer.charterS2Intro,
      items: [
        appLocalizer.charterS2I1,
        appLocalizer.charterS2I2,
        appLocalizer.charterS2I3,
        appLocalizer.charterS2I4,
        appLocalizer.charterS2I5,
      ],
    ),
    _CharterSection(
      title: appLocalizer.charterS3Title,
      intro: appLocalizer.charterS3Intro,
      items: [
        appLocalizer.charterS3I1,
        appLocalizer.charterS3I2,
        appLocalizer.charterS3I3,
        appLocalizer.charterS3I4,
        appLocalizer.charterS3I5,
        appLocalizer.charterS3I6,
        appLocalizer.charterS3I7,
      ],
    ),
    _CharterSection(
      title: appLocalizer.charterS4Title,
      intro: appLocalizer.charterS4Intro,
      items: [
        appLocalizer.charterS4I1,
        appLocalizer.charterS4I2,
        appLocalizer.charterS4I3,
        appLocalizer.charterS4I4,
        appLocalizer.charterS4I5,
        appLocalizer.charterS4I6,
        appLocalizer.charterS4I7,
        appLocalizer.charterS4I8,
      ],
    ),
    _CharterSection(
      title: appLocalizer.charterS5Title,
      intro: appLocalizer.charterS5Intro,
      items: [
        appLocalizer.charterS5I1,
        appLocalizer.charterS5I2,
        appLocalizer.charterS5I3,
        appLocalizer.charterS5I4,
      ],
    ),
    _CharterSection(
      title: appLocalizer.charterS6Title,
      intro: appLocalizer.charterS6Intro,
      items: [
        appLocalizer.charterS6I1,
        appLocalizer.charterS6I2,
        appLocalizer.charterS6I3,
        appLocalizer.charterS6I4,
        appLocalizer.charterS6I5,
        appLocalizer.charterS6I6,
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sections = _sections();

    return Scaffold(
      backgroundColor: context.appColors.appBackgroundColor,
      // No bgColor override: the app bar theme already paints
      // appBackgroundColor, so the bar and the page stay in step on their own.
      appBar: AppBars.defaultBar(
        context,
        useCloseButton: true,
        text: appLocalizer.charterPageTitle,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _ReadingProgressBar(progress: _readProgress),
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      PaddingDimensions.pageHorizontalPadding,
                      PaddingDimensions.large,
                      PaddingDimensions.pageHorizontalPadding,
                      PaddingDimensions.xLarge,
                    ),
                    children: [
                      const _CharterHeader(),
                      const SizedBox(height: PaddingDimensions.xLarge),
                      for (int i = 0; i < sections.length; i++) ...[
                        _CharterSectionCard(
                          index: i + 1,
                          total: sections.length,
                          section: sections[i],
                        ),
                        const SizedBox(height: PaddingDimensions.medium),
                      ],
                      const SizedBox(height: PaddingDimensions.medium),
                      const _CharterOathCard(),
                      const SizedBox(height: PaddingDimensions.xLarge),
                      const _CharterEndMarker(),
                    ],
                  ),
                  PositionedDirectional(
                    end: PaddingDimensions.large,
                    bottom: PaddingDimensions.large,
                    child: _JumpToEndButton(
                      visible: !_reachedEnd,
                      onPressed: _jumpToEnd,
                    ),
                  ),
                ],
              ),
            ),
            _CharterConsentBar(
              reachedEnd: _reachedEnd,
              readProgress: _readProgress,
              isAgree: _isAgree,
              onAgreeChanged: (value) => setState(() => _isAgree = value),
              onSubmit: _canSubmit ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Thin bar under the app bar showing how far through the charter the reader is.
class _ReadingProgressBar extends StatelessWidget {
  final double progress;

  const _ReadingProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 200),
      builder: (context, value, _) => LinearProgressIndicator(
        value: value,
        minHeight: 3,
        // A faded pass of the same gold, so the track belongs to the bar it
        // sits in rather than reading as a stray grey line.
        backgroundColor: _CharterPalette.gold.withValues(alpha: 0.2),
        valueColor: const AlwaysStoppedAnimation<Color>(_CharterPalette.gold),
      ),
    );
  }
}

/// Opening block: what the document is, and the warning that it binds the
/// reader. Both live in one ink card so the page opens on a single statement
/// rather than two competing banners.
class _CharterHeader extends StatelessWidget {
  const _CharterHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PaddingDimensions.large),
      decoration: BoxDecoration(
        color: _CharterPalette.ink,
        borderRadius: BorderRadius.circular(Dimensions.largeRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _CharterPalette.gold.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Iconsax.shield_tick,
                  color: _CharterPalette.gold,
                  size: IconDimensions.medium,
                ),
              ),
              const SizedBox(width: PaddingDimensions.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizer.charterHeaderTitle,
                      style: context.extraBold.copyWith(
                        fontSize: Dimensions.xxxxLarge,
                        color: _CharterPalette.gold,
                      ),
                    ),
                    const SizedBox(height: PaddingDimensions.xSmall),
                    Text(
                      appLocalizer.charterHeaderSubtitle,
                      style: context.regular.copyWith(
                        fontSize: Dimensions.large,
                        height: 1.6,
                        color: _CharterPalette.onInk.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PaddingDimensions.large),
          Container(
            height: 1,
            color: _CharterPalette.gold.withValues(alpha: 0.25),
          ),
          const SizedBox(height: PaddingDimensions.large),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Iconsax.info_circle,
                color: _CharterPalette.gold,
                size: IconDimensions.xSmall,
              ),
              const SizedBox(width: PaddingDimensions.normal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizer.charterNoticeTitle,
                      style: context.bold.copyWith(
                        fontSize: Dimensions.xLarge,
                        color: _CharterPalette.onInk,
                      ),
                    ),
                    const SizedBox(height: PaddingDimensions.xSmall),
                    Text(
                      appLocalizer.charterNoticeBody,
                      style: context.regular.copyWith(
                        fontSize: Dimensions.large,
                        height: 1.7,
                        color: _CharterPalette.onInk.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CharterSectionCard extends StatelessWidget {
  final int index;
  final int total;
  final _CharterSection section;

  const _CharterSectionCard({
    required this.index,
    required this.total,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PaddingDimensions.large),
      decoration: BoxDecoration(
        // color: context.appColors.neutral.shade50,
        borderRadius: BorderRadius.circular(Dimensions.largeRadius),
        border: Border.all(color: context.appColors.neutral.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _CharterPalette.ink,
                ),
                child: Text(
                  '$index',
                  style: context.bold.copyWith(
                    fontSize: Dimensions.large,
                    color: _CharterPalette.gold,
                  ),
                ),
              ),
              const SizedBox(width: PaddingDimensions.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizer.charterSectionLabel(index, total),
                      style: context.regular.copyWith(
                        fontSize: Dimensions.large,
                        color: context.appColors.neutral.shade500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      section.title,
                      style: context.bold.copyWith(
                        fontSize: Dimensions.xxLarge,
                        height: 1.4,
                        color: context.appColors.neutral.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PaddingDimensions.medium),
          Text(
            section.intro,
            style: context.semiBold.copyWith(
              fontSize: Dimensions.large,
              height: 1.7,
              color: context.appColors.neutral.shade600,
            ),
          ),
          const SizedBox(height: PaddingDimensions.normal),
          for (final item in section.items)
            Padding(
              padding: const EdgeInsets.only(top: PaddingDimensions.normal),
              child: _CharterBullet(text: item),
            ),
        ],
      ),
    );
  }
}

class _CharterBullet extends StatelessWidget {
  final String text;

  const _CharterBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Nudged down so the dot sits on the first line's optical centre.
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _CharterPalette.gold,
            ),
          ),
        ),
        const SizedBox(width: PaddingDimensions.medium),
        Expanded(
          child: Text(
            text,
            style: context.regular.copyWith(
              fontSize: Dimensions.xLarge,
              height: 1.8,
              color: context.appColors.neutral.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

/// The oath itself, echoing the opening header's ink card so the document is
/// visually bracketed by the two things that bind: the warning and the oath.
class _CharterOathCard extends StatelessWidget {
  const _CharterOathCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PaddingDimensions.large),
      decoration: BoxDecoration(
        color: _CharterPalette.ink,
        borderRadius: BorderRadius.circular(Dimensions.largeRadius),
        border: Border.all(color: _CharterPalette.gold, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.book,
                color: _CharterPalette.gold,
                size: IconDimensions.normal,
              ),
              const SizedBox(width: PaddingDimensions.normal),
              Text(
                appLocalizer.charterOathTitle,
                style: context.extraBold.copyWith(
                  fontSize: Dimensions.xxxxLarge,
                  color: _CharterPalette.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: PaddingDimensions.medium),
          Container(
            height: 1,
            color: _CharterPalette.gold.withValues(alpha: 0.25),
          ),
          const SizedBox(height: PaddingDimensions.medium),
          Text(
            appLocalizer.charterOathBody,
            style: context.medium.copyWith(
              fontSize: Dimensions.xLarge,
              height: 2,
              color: _CharterPalette.onInk,
            ),
          ),
        ],
      ),
    );
  }
}

class _CharterEndMarker extends StatelessWidget {
  const _CharterEndMarker();

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 1, color: context.appColors.neutral.shade300),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingDimensions.medium,
          ),
          child: Text(
            appLocalizer.charterEndOfDocument,
            style: context.regular.copyWith(
              fontSize: Dimensions.large,
              color: context.appColors.neutral.shade500,
            ),
          ),
        ),
        line,
      ],
    );
  }
}

/// Shortcut for readers who have already made up their mind — it skips to the
/// end of the charter instead of leaving them stuck scrolling.
class _JumpToEndButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  const _JumpToEndButton({required this.visible, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(
        ignoring: !visible,
        child: Semantics(
          button: true,
          label: appLocalizer.charterGoToEnd,
          child: Material(
            color: _CharterPalette.ink,
            shape: const CircleBorder(),
            elevation: 3,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Iconsax.arrow_down_1,
                  color: _CharterPalette.gold,
                  size: IconDimensions.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The pinned footer. While the charter is still being read it stays a slim
/// progress line; reaching the end swaps it for the acknowledgement, so the
/// reader never faces a checkbox they are not yet allowed to tick.
class _CharterConsentBar extends StatelessWidget {
  final bool reachedEnd;
  final double readProgress;
  final bool isAgree;
  final ValueChanged<bool> onAgreeChanged;
  final VoidCallback? onSubmit;

  const _CharterConsentBar({
    required this.reachedEnd,
    required this.readProgress,
    required this.isAgree,
    required this.onAgreeChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        PaddingDimensions.pageHorizontalPadding,
        PaddingDimensions.medium,
        PaddingDimensions.pageHorizontalPadding,
        PaddingDimensions.large,
      ),
      decoration: BoxDecoration(
        // The page's own background, not neutral.shade50 — that shade inverts
        // to pure black in dark mode and turned the footer into a slab darker
        // than everything around it. The top border and shadow are what set
        // the bar apart from the content, not a different fill.
        color: context.appColors.appBackgroundColor,
        border: Border(
          top: BorderSide(color: context.appColors.neutral.shade300),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 260),
            sizeCurve: Curves.easeOutCubic,
            crossFadeState: reachedEnd
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: _ReadingStatusRow(progress: readProgress),
            secondChild: _AgreementCheckbox(
              value: isAgree,
              onChanged: onAgreeChanged,
            ),
          ),
          const SizedBox(height: PaddingDimensions.medium),
          AppPrimaryButton(
            onPressed: onSubmit,
            isExpanded: true,
            text: appLocalizer.charterSwearButton,
            // The theme's disabled background is barely darker than the footer
            // itself; this keeps the locked button clearly visible — and
            // clearly locked — while leaving the enabled look untouched.
            buttonStyle: (current) =>
                current?.copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.disabled)
                        ? context.appColors.neutral.shade300
                        : current.backgroundColor?.resolve(states),
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.disabled)
                        ? context.appColors.neutral.shade600
                        : current.foregroundColor?.resolve(states),
                  ),
                ) ??
                current,
          ),
        ],
      ),
    );
  }
}

/// Says what is still left to do while the charter is being read, so the
/// locked button below is never a dead end.
class _ReadingStatusRow extends StatelessWidget {
  final double progress;

  const _ReadingStatusRow({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Iconsax.arrow_down_1,
          size: IconDimensions.xxSmall,
          color: _CharterPalette.gold,
        ),
        const SizedBox(width: PaddingDimensions.normal),
        Flexible(
          child: Text(
            appLocalizer.charterScrollHint,
            textAlign: TextAlign.center,
            style: context.regular.copyWith(
              fontSize: Dimensions.large,
              color: context.appColors.neutral.shade600,
            ),
          ),
        ),
        const SizedBox(width: PaddingDimensions.normal),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingDimensions.normal,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: context.appColors.neutral.shade200,
            borderRadius: BorderRadius.circular(Dimensions.regularRadius),
          ),
          child: Text(
            appLocalizer.charterReadPercent((progress * 100).round()),
            style: context.semiBold.copyWith(
              fontSize: Dimensions.large,
              color: context.appColors.neutral.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

class _AgreementCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AgreementCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(PaddingDimensions.medium),
        decoration: BoxDecoration(
          // A translucent wash of the same gold, so the checked state reads
          // identically over the light and the dark surface.
          color: value
              ? _CharterPalette.gold.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.mediumRadius),
          border: Border.all(
            color: value
                ? _CharterPalette.gold
                : context.appColors.neutral.shade300,
            width: value ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value ? _CharterPalette.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.smallRadius),
                border: Border.all(
                  color: value
                      ? _CharterPalette.gold
                      : context.appColors.neutral.shade400,
                  width: 1.5,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: _CharterPalette.ink,
                    )
                  : null,
            ),
            const SizedBox(width: PaddingDimensions.medium),
            Expanded(
              child: Text(
                appLocalizer.charterAgreeCheckbox,
                style: context.semiBold.copyWith(
                  fontSize: Dimensions.large,
                  height: 1.6,
                  color: context.appColors.neutral.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
