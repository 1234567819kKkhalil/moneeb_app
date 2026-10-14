import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'core/core_imports.dart';
import 'core/app_material/material.dart';
import 'core/utils/utils_imports.dart';
import 'features/authentication/authentication_imports.dart';
import 'features/authentication/src/presentation/ui/get_started/pages/get_started_page.dart';
import 'features/main_host_page/main_host_page_imports.dart';

class BuilderScreen extends StatelessWidget {
  const BuilderScreen({super.key});

  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthState>(
      listenWhen: (previous, current) {
        return current.actionState != previous.actionState;
      },
      listener: (context, state) {
        if (state.actionState.status.isLoading) {
          AppBlockerLoader.showLoader(context);
        } else {
          AppBlockerLoader.removeLoader();
        }

        if (state.actionState.status.isFailure) {
          AppToasts.error(
            context,
            message: state.actionState.status.failure?.errorMessage ?? '',
          );
        }
      },
      buildWhen: (previous, current) =>
          current.routingState != previous.routingState ||
          current.userData != previous.userData,
      builder: (context, state) {
        final userData = state.userData.data;

        int animationDurationInMill = 400;

        final root;

        switch (state.routingState.route) {
          case AuthRouteEnum.deciderPage:
            root = const DeciderPage();
            break;

          case AuthRouteEnum.getStartedPage:
            root = const GetStartedPage();
            break;


          case AuthRouteEnum.guest:
            root = const MainHostPage();
            break;

          case AuthRouteEnum.authenticated:
            if(userData?.role == UserRoleEnum.provider && userData?.providerData?.isCompletedProfile == false){
              root = const ProviderCompleteProfilePage();
            } else {
              root = const MainHostPage();
            }

            break;
        }

        return AnimatedSwitcher(
          duration: Duration(milliseconds: animationDurationInMill),
          child: ColoredBox(
            color: context.appColors.appBackgroundColor,
            key: ObjectKey(state.routingState),
            child: root,
          ),
        );
      },
    );
  }
}
