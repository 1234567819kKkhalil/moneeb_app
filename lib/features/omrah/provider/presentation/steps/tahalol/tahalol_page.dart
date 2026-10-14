import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/presentation/veritifcation_pages/provider_image_verification_upload_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/veritifcation_pages/provider_video_verification_upload_page.dart';
// import 'package:moneeb/features/omrah/provider/presentation/steps/makam/data/repo/makam_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/mekat/data/repo/mekat_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/safa_and_marwa/data/repo/safa_and_marwa_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/tawaf/data/repo/tawaf_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/for_whom_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/rejected_proof_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/instructions_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_omrah_cubit/provider_omrah_cubit.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/omrah_verification_card.dart';

class TahalolPage extends StatelessWidget {
  final ProviderOmrahCubit omrahCubitRef;

  const TahalolPage({super.key, required this.omrahCubitRef});

  static const String routeName = "TahalolPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: omrahCubitRef,
      child: const _TahalolPageBody(),
    );
  }
}

class _TahalolPageBody extends StatefulWidget {
  const _TahalolPageBody({super.key});

  @override
  State<_TahalolPageBody> createState() => _TahalolPageBodyState();
}

class _TahalolPageBodyState extends State<_TahalolPageBody> {

  @override
  Widget build(BuildContext context) {
    final forWhom = context.read<ProviderOmrahCubit>().forWhom;

    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        useCloseButton: true,
        centerTitle: true,
        text: OmrahStepsEnum.tahalol.getPhaseTitle(),
      ),
      body: SafeArea(
        child: BlocBuilder<ProviderOmrahCubit, ProviderOmrahState>(
          builder: (context, state) {
            final tahalolStepData = state.getOmrahStepData(OmrahStepsEnum.tahalol);

            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                ForWhomCard(
                  forWhom: forWhom,
                ),

                RejectedProofCard(step: tahalolStepData),

                Gap(20),

                Text(
                  appLocalizer.tahalolVerifyTitle,
                  style: context.bold,
                ),

                Gap(12),

                Text(
                  appLocalizer.tahalolVerifyVideo,
                  style: context.regular.copyWith(fontSize: 12),
                ),

                Gap(16),

                OmrahVerificationCard(
                  title: appLocalizer.tahalolVerifyImageDesc,
                  onTap: () {
                    AppRouteNavigator.push(
                      context,
                      ProviderImageVerificationUploadPage.routeName,
                      ProviderImageVerificationUploadPage(
                        omrahCubitRef: context.read<ProviderOmrahCubit>(),
                        stepType: OmrahStepsEnum.tahalol,
                      )
                    );
                  },
                ),

                Gap(16),

                OmrahVerificationCard(
                  title: appLocalizer.tahalolVerifyVideoDesc,
                  isVerified: tahalolStepData.hasAcceptedVideoProof,
                  onTap: () {
                    AppRouteNavigator.push(
                        context,
                        ProviderVideoVerificationUploadPage.routeName,
                        ProviderVideoVerificationUploadPage(
                          omrahCubitRef: context.read<ProviderOmrahCubit>(),
                          stepType: OmrahStepsEnum.tahalol,
                        )
                    );
                  },
                ),

                Gap(16),
              ],
            );
          },
        ),
      ),
    );
  }
}
