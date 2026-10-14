import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/home/home_imports.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';
import 'package:moneeb/features/home/src/presentation/widgets/provider_omrah_floating_steps/draggable_mixin.dart';
import 'package:moneeb/features/home/src/presentation/widgets/provider_omrah_floating_steps/floating_omrah_manager.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/presentation/provider_omrah_page.dart';

class ProviderOmrahOverlayView extends StatefulWidget {
  final OmrahStepperEntity omrahData;
  const ProviderOmrahOverlayView({super.key, required this.omrahData});

  @override
  State<ProviderOmrahOverlayView> createState() =>
      _ProviderOmrahOverlayViewState();
}

class _ProviderOmrahOverlayViewState extends State<ProviderOmrahOverlayView>
    with DraggableOverlayMixin {
  @override
  double get defaultHeight => context.adaptiveHeight / 6;

  @override
  double get defaultWidth => context.adaptiveWidth / 3;

  @override
  void onRemoveOverlay() {
    FloatingOmrahOverlayManager.removeOverlay();
  }

  @override
  Widget get children => GestureDetector(
    onTap: () {
      AppRouteNavigator.push(
        context,
        ProviderOmrahPage.routeName,
        ProviderOmrahPage(
          orderId: widget.omrahData.orderId,
          forWhom: widget.omrahData.forWhom,
          targetDate: widget.omrahData.targetDate,
        ),
      );
    },
    child: Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary500.withOpacity(0.5),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(8),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              appLocalizer.ongoingOmrah,
              style: context.bold.copyWith(fontSize: 12),
            ),
          ),

          Gap(8),

          AppSvg(
            svgPath: widget.omrahData.currentStep.getSvgIcon(),
            width: 18,
            height: 18,
            color: context.appColors.neutral.shade900,
          ),

          Gap(4),

          Text(
            widget.omrahData.currentStep.getMinimizedLocalizedName(),
            style: context.medium.copyWith(
              color: AppColors.neutral50,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          Gap(8),
        ],
      ),
    ),
  );
}
