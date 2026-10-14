import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

class LanguagePickerBottomSheet extends StatefulWidget {
  final bool ignoreEqualityCheck;
  const LanguagePickerBottomSheet({
    super.key,
    this.ignoreEqualityCheck = false,
  });

  @override
  State<LanguagePickerBottomSheet> createState() =>
      _LanguagePickerBottomSheetState();
}

class _LanguagePickerBottomSheetState extends State<LanguagePickerBottomSheet> {
  AppLangCodeEnum _selectedLang = injector<LocalizationContainer>().langCode;
  List<AppLangCodeEnum> _langList = AppLangCodeEnum.values;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizer.select_language,
                    style: context.semiBold.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    appLocalizer.select_your_language,
                    style: context.regular.copyWith(
                      color: AppColors.neutral500,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...List.generate(_langList.length, (index) {
                    final lang = _langList[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: AppRadioTile<AppLangCodeEnum>(
                        title: lang.getName,
                        value: lang,
                        groupValue: _selectedLang,
                        onChanged: (value) {
                          setState(() {
                            _selectedLang = value;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          AppPrimaryButton(
            onPressed: () {
              AppRouteNavigator.popUntil(context);

              if (widget.ignoreEqualityCheck) {
                context.read<AppLanguageCubit>().changeLanguage(_selectedLang);
              } else {
                if (_selectedLang !=
                    injector<LocalizationContainer>().langCode) {
                  context.read<AppLanguageCubit>().changeLanguage(
                    _selectedLang,
                  );
                }
              }
            },
            text: appLocalizer.save,
            isExpanded: true,
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
