import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

class OmrahVerificationCard extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final bool isVerified;
  final bool isLoading;
  const OmrahVerificationCard({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.isVerified =  false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(18));

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Material(
            color: context.appColors.primary.shade400,
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: (){
                if(isVerified){
                  AppToasts.success(context, message: appLocalizer.proofAlreadySubmitted);
                  return;
                }
                onTap();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(color: context.appColors.secondary.shade500),
                ),
                padding: EdgeInsets.symmetric(vertical: 28, horizontal: 18),
                child: isLoading
                    ? Center(child: SizedBox(height: 20, width:20,child: CircularProgressIndicator(strokeWidth: 3,)))
                    : Text(title, style: context.bold, textAlign: TextAlign.center),
              ),
            ),
          ),
        ),

        if(isVerified)
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: context.appColors.secondary.shade500,
              borderRadius: BorderRadius.only(
                // topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.check_circle_outlined,
              color: context.appColors.primary.shade400,
              size: 20,
            ),
          )

        )
      ],
    );
  }
}
