part of tazkiyah;

class MyTazkiyahsPage extends StatefulWidget {
  static const routeName = '/my-tazkiyahs';

  const MyTazkiyahsPage({super.key});

  @override
  State<MyTazkiyahsPage> createState() => _MyTazkiyahsPageState();
}

class _MyTazkiyahsPageState extends State<MyTazkiyahsPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Validator _validator = Validator();

  LoginInputType _type = LoginInputType.email;
  PhoneNumber? _phoneNumber;

  /// The contact the last search ran with, shown on the tazkiyah screen.
  String _searchedContact = '';

  bool get _isPhone => _type == LoginInputType.phone;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSearch(TazkiyahCubit cubit) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_isPhone) {
      final phone = _phoneNumber;
      if (phone == null || phone.nationalNumber.isEmpty) {
        AppToasts.error(context, message: appLocalizer.invalidPhoneNumber);
        return;
      }
      _searchedContact = phone.internationalNumber;
      cubit.searchProvider(phone: phone);
    } else {
      final email = _emailController.text.trim();
      _searchedContact = email;
      cubit.searchProvider(email: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<TazkiyahCubit>()..getMyTazkiyahs(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<TazkiyahCubit>();

          return Scaffold(
            backgroundColor: context.appColors.appBackgroundColor,
            appBar: AppBars.defaultBar(
              context,
              text: appLocalizer.tazkiyah_settings,
              centerTitle: true,
              useCloseButton: true,
            ),
            body: BlocListener<TazkiyahCubit, TazkiyahState>(
              listenWhen: (previous, current) =>
                  previous.searchResult != current.searchResult,
              listener: (context, state) {
                if (state.searchResult.isFailure) {
                  AppToasts.error(
                    context,
                    message:
                        state.searchResult.failure?.errorMessage ??
                        appLocalizer.unexpectedError,
                  );
                }
                if (state.searchResult.isSuccess &&
                    state.searchResult.data != null) {
                  AppRouteNavigator.push(
                    context,
                    TazkiyahPage.routeName,
                    TazkiyahPage(
                      provider: state.searchResult.data!,
                      providerContact: _searchedContact,
                    ),
                    onPoppedWithData: (data) {
                      if (data is MyTazkiyahEntity) {
                        cubit.addTazkiyahLocally(data);
                      }
                    },
                  );
                  cubit.clearProvider();
                }
              },
              child: BlocBuilder<TazkiyahCubit, TazkiyahState>(
                builder: (context, state) {
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: PaddingDimensions.pageHorizontalPadding,
                            right: PaddingDimensions.pageHorizontalPadding,
                            top: PaddingDimensions.normal,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalizer.tazkiyahTitle,
                                style: context.semiBold.copyWith(
                                  color: context.appColors.secondary.shade500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                appLocalizer.tazkiyahDesc,
                                style: context.medium.copyWith(
                                  color: context.appColors.neutral.shade900,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),

                        // Search card: email/phone switch, the matching field,
                        // then a full-width search action underneath.
                        Padding(
                          padding: const EdgeInsets.only(
                            left: PaddingDimensions.pageHorizontalPadding,
                            right: PaddingDimensions.pageHorizontalPadding,
                            bottom: PaddingDimensions.normal,
                          ),
                          child: Container(
                            // padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              // color: context.appColors.primary.shade400,
                              borderRadius: BorderRadius.circular(16),
                              /*  border: Border.all(
                                color: context.appColors.primary.shade300,
                              ), */
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    appLocalizer.searchByEmailOrPhone,
                                    style: context.medium.copyWith(
                                      color: context.appColors.neutral.shade900,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  IdentifierTypeToggle(
                                    selected: _type,
                                    onChanged: (type) {
                                      if (type != _type) {
                                        setState(() => _type = type);
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  if (_isPhone)
                                    PhoneField(
                                      hint: appLocalizer.mobileNumberHint,
                                      onChange: (number) =>
                                          _phoneNumber = number,
                                    )
                                  else
                                    EmailWidget(
                                      controller: _emailController,
                                      validator: (text) => _validator
                                          .emailValidation(text ?? ''),
                                    ),
                                  const SizedBox(height: 18),
                                  AppPrimaryButton(
                                    isExpanded: true,
                                    isLoading: state.searchResult.isLoading,
                                    onPressed: state.searchResult.isLoading
                                        ? null
                                        : () => _onSearch(cubit),
                                    text: appLocalizer.search,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12),
                        // Section title
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PaddingDimensions.pageHorizontalPadding,
                          ),
                          child: Text(
                            appLocalizer.previousTazkiyahs,
                            style: context.bold.copyWith(
                              color: context.appColors.neutral.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // My Tazkiyahs list
                        Expanded(child: _buildMyTazkiyahsList(context, state)),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  static final _skeletonItems = List.generate(
    5,
    (i) => MyTazkiyahEntity(
      id: 'skeleton-$i',
      providerId: '',
      providerName: 'محمد عبدالله المبارك',
      reason: 'شخص أمين وملتزم وموثوق به في جميع تعاملاته',
      agreedToOath: true,
      createdAt: DateTime.now(),
    ),
  );

  Widget _buildMyTazkiyahsList(BuildContext context, TazkiyahState state) {
    if (state.myTazkiyahsResult.isLoading) {
      return AppSkeletonizer(
        isEnabled: true,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingDimensions.pageHorizontalPadding,
            vertical: 8,
          ),
          itemCount: _skeletonItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _MyTazkiyahItem(tazkiyah: _skeletonItems[index]),
        ),
      );
    }

    if (state.myTazkiyahsResult.isFailure) {
      return Center(
        child: Text(
          state.myTazkiyahsResult.failure?.errorMessage ??
              appLocalizer.unexpectedError,
          style: context.regular.copyWith(
            color: context.appColors.neutral.shade600,
          ),
        ),
      );
    }

    final list = state.myTazkiyahsResult.data ?? [];

    if (list.isEmpty) {
      return Center(
        child: Text(
          appLocalizer.noTazkiyahsYet,
          style: context.regular.copyWith(
            color: context.appColors.neutral.shade600,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingDimensions.pageHorizontalPadding,
        vertical: 8,
      ),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _MyTazkiyahItem(tazkiyah: list[index]),
    );
  }
}

class _MyTazkiyahItem extends StatefulWidget {
  final MyTazkiyahEntity tazkiyah;

  const _MyTazkiyahItem({required this.tazkiyah});

  @override
  State<_MyTazkiyahItem> createState() => _MyTazkiyahItemState();
}

class _MyTazkiyahItemState extends State<_MyTazkiyahItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final formattedDate = intel.DateFormat(
      'dd MMM yyyy',
      injector<LocalizationContainer>().langCode.name,
    ).format(widget.tazkiyah.createdAt);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appColors.neutral.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.neutral.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: context.appColors.backgroundColorForProviderCard,
            ),
            clipBehavior: Clip.hardEdge,
            child: widget.tazkiyah.providerAvatarUrl != null
                ? AppImage(
                    path: widget.tazkiyah.providerAvatarUrl!,
                    errorPlaceHolder: () => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        AssetPaths.moneebLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : AppImage(
                    path: AssetPaths.moneebLogo,
                    fit: BoxFit.contain,
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(100),
                  ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.tazkiyah.providerName,
                        style: context.semiBold.copyWith(
                          color: context.appColors.neutral.shade900,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: context.regular.copyWith(
                        color: context.appColors.neutral.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.tazkiyah.reason,
                  style: context.regular.copyWith(
                    color: context.appColors.neutral.shade700,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  maxLines: _expanded ? null : 1,
                  overflow: _expanded ? null : TextOverflow.ellipsis,
                ),
                // Show expand button only if reason is longer than 1 line
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textSpan = TextSpan(
                      text: widget.tazkiyah.reason,
                      style: context.regular.copyWith(
                        color: context.appColors.neutral.shade700,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    );
                    final textPainter = TextPainter(
                      text: textSpan,
                      maxLines: 1,
                      textDirection: TextDirection.rtl,
                    )..layout(maxWidth: constraints.maxWidth);

                    if (!textPainter.didExceedMaxLines) return const SizedBox();

                    return GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _expanded
                              ? appLocalizer.showLess
                              : appLocalizer.showMore,
                          style: context.semiBold.copyWith(
                            color: context.appColors.secondary.shade500,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                context.appColors.secondary.shade500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
