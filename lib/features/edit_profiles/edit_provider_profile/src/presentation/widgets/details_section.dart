part of edit_provider_profile;

class DetailsSection extends StatefulWidget {
  final AppUserModel userModel;

  const DetailsSection({super.key, required this.userModel});

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
  IntelPhoneCountry? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = countries.firstWhereOrNull(
      (c) => c.code == widget.userModel.country,
    );
  }

  /// Resolved on every build so it follows the current app language.
  String get _countryName => injector<LocalizationContainer>().langCode.isArabic
      ? _selectedCountry?.arabicName ?? ''
      : _selectedCountry?.name ?? '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            appLocalizer.details,
            style: context.bold.copyWith(
              fontSize: 14,
              color: context.appColors.secondary.shade500,
            ),
          ),
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: _DetailCard(
                text: widget.userModel.email,
                iconPath: AssetPaths.iconEmail,
                textDirection: TextDirection.ltr,
              ),
            ),
            const Gap(12),
            Expanded(
              child: _DetailCard(
                text: _countryName,
                countryIcon: _selectedCountry?.flag,
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: _DetailCard(
                text: widget.userModel.phone,
                iconPath: AssetPaths.iconPhone,
                textDirection: TextDirection.ltr,
              ),
            ),
            const Gap(12),
            Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String text;
  final String? iconPath;
  final String? countryIcon;

  /// Forced for latin values (email, phone) so a leading `+` is not pushed to
  /// the end of the line by the RTL paragraph direction.
  final TextDirection? textDirection;

  const _DetailCard({
    required this.text,
    this.iconPath,
    this.countryIcon,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    // The paragraph direction may be forced to LTR, but the value must stay
    // aligned to the ambient (screen) direction next to its icon.
    final bool isRtlScreen = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: context.appColors.primary.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (iconPath != null)
            SvgPicture.asset(
              iconPath!,
              width: 20,
              height: 20,
              colorFilter:
                  iconPath == AssetPaths.iconEmail ||
                      iconPath == AssetPaths.iconPhone
                  ? ColorFilter.mode(
                      context.appColors.neutral.shade50,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
          const Gap(12),
          Expanded(
            child: Text(
              text,
              style: context.medium.copyWith(
                fontSize: 12,
                color: context.appColors.neutral.shade50,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: isRtlScreen ? TextAlign.right : TextAlign.left,
              textDirection: textDirection,
            ),
          ),
          if (countryIcon != null) Text(countryIcon!),
        ],
      ),
    );
  }
}
