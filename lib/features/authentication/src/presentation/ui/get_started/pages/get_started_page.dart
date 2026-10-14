import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/app_material/src/bottom_sheet/language_picker/language_picker_bottom_sheet.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!injector<SharedPreferencesHelper>().isUserSetLanguage) {
        AppBottomSheets.showAppBottomSheet(
          context,
          useSafeArea: true,
          useCloseButton: true,
          builder: (context) {
            return LanguagePickerBottomSheet(ignoreEqualityCheck: true);
          },
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: AppImage(
              path: AssetPaths.kaabaBg,
              width: context.width,
              height: context.height,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: 48,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              child: Column(
                children: [
                  /* Text(
                    appLocalizer.welcomeToMoneeb,
                    style: context.extraBold.copyWith(
                      fontSize: 20,
                      color: context.appColors.secondary.shade500
                    ),
                  ),
 */
                  Gap(16),

                  AppImage(path: AssetPaths.moneebLogo, width: 100, height: 50),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          appLocalizer.omrahForYouOrLovedOne,
                          style: context.semiBold.copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),

                        Gap(4),

                        Text(
                          appLocalizer.docTrackComply,
                          style: context.regular.copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  AppPrimaryButton(
                    isExpanded: true,
                    onPressed: () {
                      AppRouteNavigator.push(
                        context,
                        LoginPage.routeName,
                        const LoginPage(),
                      );
                    },
                    text: appLocalizer.continueBtn,
                  ),

                  AppTextButton(
                    text: appLocalizer.continueAsGuest,
                    onPressed: () {
                      AuthenticationBloc.of(context).add(GuestEvent());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
