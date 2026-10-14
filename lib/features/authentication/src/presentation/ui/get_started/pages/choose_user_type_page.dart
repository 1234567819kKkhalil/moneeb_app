import 'package:flutter/material.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';

class ChooseUserTypePage extends StatefulWidget {
  const ChooseUserTypePage({super.key});

  static const String routeName = "ChooseUserTypePage";

  @override
  State<ChooseUserTypePage> createState() => _ChooseUserTypePageState();
}

class _ChooseUserTypePageState extends State<ChooseUserTypePage> {
  UserRoleEnum selectedRole = UserRoleEnum.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppImage(
                        path: AssetPaths.moneebLogo,
                        width: 150,
                        height: 100,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "﴿وَأَتِمُّوا الْحَجَّ وَالْعُمْرَةَ لِلَّه﴾",
                        style: context.regular.copyWith(
                          fontSize: 18,
                          fontFamily: 'KFGQPC',
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 64),

                      Text(
                        appLocalizer.chooseAccountType,
                        style: context.semiBold.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        appLocalizer.selectServiceToContinue,
                        style: context.regular,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      AppRadioTile<UserRoleEnum>(
                        value: UserRoleEnum.user,
                        groupValue: selectedRole,
                        onChanged: (val) => setState(() => selectedRole = val),
                        title: appLocalizer.requestOmrahTitle,
                      ),

                      const SizedBox(height: 16),

                      AppRadioTile<UserRoleEnum>(
                        value: UserRoleEnum.provider,
                        groupValue: selectedRole,
                        onChanged: (val) => setState(() => selectedRole = val),
                        title: appLocalizer.providerServiceTitle,
                      ),

                      const Spacer(),

                      const SizedBox(height: 32),

                      AppPrimaryButton(
                        isExpanded: true,
                        buttonHeight: 56,
                        text: appLocalizer.startBtnAuth,
                        onPressed: () {
                          AuthenticationBloc.of(context).modifyUserModel((
                            userModel,
                          ) {
                            return userModel.copyWith(role: selectedRole);
                          });

                          AppRouteNavigator.pushReplacement(
                            context,
                            LoginPage.routeName,
                            const LoginPage(),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.center,
                        child: AppTextButton(
                          onPressed: () {
                            AppRouteNavigator.popUntil(context);
                            AuthenticationBloc.of(context).add(GuestEvent());
                          },
                          text: appLocalizer.continueAsGuest,
                          textStyle: context.medium.copyWith(
                            color: context.appColors.secondary.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
