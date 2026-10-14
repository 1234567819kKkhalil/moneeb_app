part of tazkiyah;

class TazkiyahPage extends StatefulWidget {
  static const routeName = '/tazkiyah';

  final LookupProviderEntity provider;

  /// The contact the provider was found with: an email or an international
  /// phone number.
  final String providerContact;

  const TazkiyahPage({
    super.key,
    required this.provider,
    required this.providerContact,
  });

  @override
  State<TazkiyahPage> createState() => _TazkiyahPageState();
}

class _TazkiyahPageState extends State<TazkiyahPage> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isAgree = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<TazkiyahCubit>(),
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
                  previous.submitResult != current.submitResult,
              listener: (context, state) {
                if (state.submitResult.isSuccess) {
                  AppToasts.success(
                    context,
                    message: appLocalizer.tazkiyahSuccess,
                  );
                  final newTazkiyah = MyTazkiyahEntity(
                    id: '',
                    providerId: widget.provider.providerId,
                    providerName: widget.provider.fullName,
                    providerAvatarUrl: widget.provider.avatarUrl,
                    reason: _reasonController.text.trim(),
                    agreedToOath: _isAgree,
                    createdAt: DateTime.now(),
                  );
                  AppRouteNavigator.pop(context, data: newTazkiyah);
                } else if (state.submitResult.isFailure) {
                  final failure = state.submitResult.failure;
                  final is409 = failure is ApiRequestFailure &&
                      failure.statusCode == 409;
                  AppToasts.error(
                    context,
                    message: is409
                        ? appLocalizer.tazkiyahAlreadySubmitted
                        : failure?.errorMessage ?? appLocalizer.unexpectedError,
                  );
                  if (is409) AppRouteNavigator.pop(context);
                }
              },
              child: BlocBuilder<TazkiyahCubit, TazkiyahState>(
                buildWhen: (previous, current) =>
                    previous.submitResult != current.submitResult,
                builder: (context, state) {
                  return SafeArea(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: PaddingDimensions.pageHorizontalPadding,
                          vertical: PaddingDimensions.normal,
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
                            const SizedBox(height: 24),

                            // Provider card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: context.appColors.primary.shade400,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: context.appColors.primary.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: context.appColors
                                          .backgroundColorForProviderCard,
                                    ),
                                    child: widget.provider.avatarUrl != null
                                        ? AppImage(
                                            path: widget.provider.avatarUrl!,
                                            errorPlaceHolder: () => Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Image.asset(
                                                AssetPaths.moneebLogo,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Image.asset(
                                              AssetPaths.moneebLogo,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.provider.fullName,
                                          style: context.bold.copyWith(
                                            color: context
                                                .appColors.neutral.shade900,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          widget.providerContact,
                                          style: context.regular.copyWith(
                                            color: context
                                                .appColors.neutral.shade900,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          // LTR keeps a leading `+` from being
                                          // pushed to the end of the number,
                                          // while alignment stays with the
                                          // screen direction.
                                          textDirection: TextDirection.ltr,
                                          textAlign:
                                              Directionality.of(context) ==
                                                  TextDirection.rtl
                                              ? TextAlign.right
                                              : TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            AppTextFormField(
                              controller: _reasonController,
                              hint: appLocalizer.tazkiyahReasons,
                              maxLines: 4,
                              maxLength: 200,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return appLocalizer.pleaseEnterTazkiyahReason;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 24),
                            Text(
                              appLocalizer.kasamTitle,
                              style: context.extraBold.copyWith(
                                color: context.appColors.neutral.shade900,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              appLocalizer.oathText,
                              style: context.medium.copyWith(
                                height: 1.8,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isAgree,
                                  onChanged: (val) {
                                    setState(() {
                                      _isAgree = val ?? false;
                                    });
                                  },
                                  activeColor:
                                      context.appColors.primary.shade500,
                                ),
                                Expanded(
                                  child: Text(
                                    appLocalizer.agreeAndPledge,
                                    style: context.regular.copyWith(
                                      color:
                                          context.appColors.secondary.shade500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            AppPrimaryButton(
                              onPressed:
                                  _isAgree && !state.submitResult.isLoading
                                  ? () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        cubit.submitTazkiyah(
                                          providerId:
                                              widget.provider.providerId,
                                          reason: _reasonController.text.trim(),
                                          agreedToOath: _isAgree,
                                        );
                                      }
                                    }
                                  : null,
                              isExpanded: true,
                              isLoading: state.submitResult.isLoading,
                              text: appLocalizer.send,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
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
}
