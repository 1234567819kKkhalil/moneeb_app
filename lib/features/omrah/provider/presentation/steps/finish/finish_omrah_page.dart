import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/home/src/presentation/widgets/provider_omrah_floating_steps/floating_omrah_manager.dart';
import 'package:moneeb/features/omrah/provider/domain/repo/omrah_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_tracking_service.dart';
import 'package:moneeb/features/orders/provider_orders/provider_orders_imports.dart';

class FinishOmrahPage extends StatefulWidget {
  final String orderId;
  const FinishOmrahPage({super.key, required this.orderId});

  static const String routeName = "FinishOmrahPage";

  @override
  State<FinishOmrahPage> createState() => _FinishOmrahPageState();
}

class _FinishOmrahPageState extends State<FinishOmrahPage> {
  final _ordersRepo = injector<ProviderOrdersRepository>();
  bool isLoading = false;

  void _completeOmrah() async {
    setState(() {
      isLoading = true;
    });

    await collect(
      task: () async {
        await _ordersRepo.completeOrder(widget.orderId);
        onOmrahEnded();
      },
      onError: (failure) {
        AppToasts.error(context, message: failure.errorMessage);
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  void onOmrahEnded(){
    AppToasts.success(context, message: appLocalizer.omrahCompletedSuccessfully);

    injector<OmrahUpdater>().omrahCompleted(widget.orderId);
    FloatingOmrahOverlayManager.removeOverlay();
    ProviderTrackingService.instance.dispose();
    AppRouteNavigator.popUntil(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.omrahStepFinishOmrah,
        centerTitle: true,
        useCloseButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    AppImage(
                      width: context.width,
                      path: AssetPaths.kaabaBg,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),

                    Positioned(
                      top: 16,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: AppImage(
                          path: AssetPaths.moneebLogo,
                          width: 100,
                          height: 55,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Gap(20),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: appLocalizer.omrahJourneyFinishPrefix,
                  style: context.semiBold.copyWith(
                    fontSize: 16
                  ),
                  children: [
                    TextSpan(text: appLocalizer.omrahWord , style: context.semiBold.copyWith(
                      color: context.appColors.secondary.shade500,
                        fontSize: 16
                    )),
                  ]
                ),
              ),

              Gap(20),

              Text(
                appLocalizer.afterSpiritualJourneyDesc,
                style: context.regular,
                textAlign: TextAlign.center,
              ),

              Gap(24),

              Expanded(
                child: SizedBox(),
              ),

              AppPrimaryButton(
                text: appLocalizer.finish,
                isExpanded: true,
                isLoading: isLoading,
                onPressed: () {
                  _completeOmrah();
                },
              ),

              Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}
