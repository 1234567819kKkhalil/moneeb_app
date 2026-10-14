/* import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneeb/controller/zad/prayer_times_controller.dart';
import 'package:moneeb/model/test/prayer_test.dart';
import 'package:moneeb/model/zad/prayer_result.dart';
import 'package:moneeb/utils/app_color.dart';
import 'package:moneeb/utils/app_config.dart';
import 'package:moneeb/utils/app_text.dart';
import 'package:moneeb/utils/constants.dart';
import 'package:moneeb/widget/custom_animation_loading.dart';
import 'package:moneeb/widget/screens/custom_divider.dart';
import 'package:moneeb/widget/screens/zad/prayer_item.dart';

class PrayerTimesScreen extends StatelessWidget {
  final _controller = Get.put(PrayerTimesController());
  PrayerTimesScreen({super.key});

  final double size = 260;
  late double progress = _controller.prayerTimes.progress; // 0%

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // height you want
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              transform: GradientRotation(500),
              tileMode: TileMode.mirror,
              stops: [2, 5],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.colorBGMain,
                AppColors.colorBGSub, // Dark color at top
                // Slightly lighter at bottom
              ],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 80,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                AppConfig.arrowBack(),
                fit: BoxFit.scaleDown,
              ),
            ),
            title: AppText.medium(
              text: 'المواقيت',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.colorBGMain,
              AppColors.colorBGSub, // Dark color at top
              // Slightly lighter at bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: FutureBuilder(future: _controller.getPrayersTimes(), builder: (_, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Container(
                  //           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  //           decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadiusGeometry.circular(12)
                  //           ),
                  //           child: AppText.medium(text: 'السعودية',fontSize: 14, color: AppColors.colorAppMain),
                  //         ),
                  //       ),
                  //       SizedBox(width: 16),
                  //       Expanded(
                  //         child: Container(
                  //           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  //           decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadiusGeometry.circular(12)
                  //           ),
                  //           child: AppText.medium(text: 'حي الرمال',fontSize: 14, color: AppColors.colorAppMain),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 18),
                  _prayerCircle(),
                  SizedBox(height: 40),
                  AppText.medium(text: 'اليوم', fontSize: 16),
                  SizedBox(height: 14),
                  CustomDivider(text: '${_controller.prayer.date!.hijri!.weekday!.ar} , ${_controller.prayer.date!.hijri!.month!.ar} , ${_controller.prayer.date!.hijri!.date} هـ,'),
                  SizedBox(height: 20),
                  _fajrPrayer(),
                  _sunrisePrayer(),
                  _dhuhrPrayer(),
                  _asrPrayer(),
                  _maghribPrayer(),
                  _ishaPrayer(),
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     physics: BouncingScrollPhysics(),
                  //     itemCount: _controller.prayers.length,
                  //     itemBuilder: (_, index) {
                  //       PrayerTest prayer = _controller.prayers[index];
                  //       return PrayerItem(prayers: prayer, prayer: _controller.prayer);
                  //     }),
                  SizedBox(height: 40),

                ],
              );
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CustomAnimationLoading()),
                ],
              );
            }else {
              return SizedBox.shrink();
            }
          }),
        ),
      ),
    );
  }

  Widget _prayerCircle() {

    final radius = size / 2;
    final angle = (2 * pi * progress) - pi / 2;
    // -pi/2 makes it start from top

    final iconX = radius + radius * cos(angle);
    final iconY = radius + radius * sin(angle);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [

          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                // color: AppColors.colorAppMain,
                borderRadius: BorderRadius.circular(150)
            ),
            child: CircularProgressIndicator(
              value: _controller.prayerTimes.progress,
              strokeWidth: 12,
              strokeAlign: 1.5,
              backgroundColor: AppColors.colorAppMain,
              valueColor: const AlwaysStoppedAnimation(AppColors.colorAppSub),
            ),
          ),

          // Moving icon
          Positioned(
            left: iconX - 8, // half icon size
            top: iconY - 18,
            child: SvgPicture.asset('${Const.icons}icon_prayer_time.svg'),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.medium(
                text: _controller.prayerTimes.next,
                textAlign: TextAlign.center,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 12),
              AppText.medium(
                text: 'باقي',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 14),
              GetBuilder<PrayerTimesController>(builder: (controller) => AppText.medium(
                text: _controller.formatDuration(_controller.prayerTimes.remaining),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              )),
            ],
          ),

        ],
      ),
    );
  }

  Color getPrayerColor(String prayer, PrayerResult result) {
    if (prayer == result.current) return AppColors.colorAppMain;
    if (prayer == result.next) return Colors.white;
    return AppColors.colorSelected;
  }

  Widget _fajrPrayer() => Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
    decoration: BoxDecoration(
        color: getPrayerColor('صلاة الفجر', _controller.prayerTimes),
        borderRadius: BorderRadius.circular(12)
    ),
    child: Row(
      children: [
        SvgPicture.asset('${Const.icons}icon_prayer_coming.svg'),
        SizedBox(width: 12),
        Expanded(child: AppText.medium(text: 'صلاة الفجر',fontSize: 15, color: AppColors.colorAppMain)),
        AppText.medium(text: _controller.prayer.timings!.fajr!,fontSize: 15, color: AppColors.colorAppMain)
      ],
    ),
  );

  Widget _sunrisePrayer() => Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
    decoration: BoxDecoration(
        color: getPrayerColor('الشروق', _controller.prayerTimes),
        borderRadius: BorderRadius.circular(12)
    ),
    child: Row(
      children: [
        SvgPicture.asset('${Const.icons}icon_prayer_coming.svg'),
        SizedBox(width: 12),
        Expanded(child: AppText.medium(text: 'الشروق',fontSize: 15, color: AppColors.colorAppMain)),
        AppText.medium(text: _controller.prayer.timings!.sunrise!,fontSize: 15, color: AppColors.colorAppMain)
      ],
    ),
  );

  Widget _dhuhrPrayer() => Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
    decoration: BoxDecoration(
        color: getPrayerColor('صلاة الظهر', _controller.prayerTimes),
        borderRadius: BorderRadius.circular(12)
    ),
    child: Row(
      children: [
        SvgPicture.asset('${Const.icons}icon_prayer_missed.svg'),
        SizedBox(width: 12),
        Expanded(child: AppText.medium(text: 'صلاة الظهر',fontSize: 15, color: AppColors.colorBGOTP)),
        AppText.medium(text: _controller.prayer.timings!.dhuhr!,fontSize: 15, color: AppColors.colorBGOTP)
      ],
    ),
  );

  Widget _asrPrayer() => Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
    decoration: BoxDecoration(
        color: getPrayerColor('صلاة العصر', _controller.prayerTimes),
        borderRadius: BorderRadius.circular(12)
    ),
    child: Row(
      children: [
        SvgPicture.asset('${Const.icons}icon_prayer_missed.svg'),
        SizedBox(width: 12),
        Expanded(child: AppText.medium(text: 'صلاة العصر',fontSize: 15, color: AppColors.colorBGOTP)),
        AppText.medium(text: _controller.prayer.timings!.asr!,fontSize: 15, color: AppColors.colorBGOTP)
      ],
    ),
  );

  Widget _maghribPrayer() => Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        color: getPrayerColor('صلاة المغرب', _controller.prayerTimes),
        borderRadius: BorderRadius.circular(12)
    ),
    child: Row(
      children: [
        SvgPicture.asset('${Const.icons}icon_prayer_current.svg'),
        SizedBox(width: 12),
        Expanded(child: AppText.medium(text: 'صلاة المغرب',fontSize: 15, color: AppColors.colorWhite)),
        AppText.medium(text: _controller.prayer.timings!.maghrib!,fontSize: 15, color: AppColors.colorWhite)
      ],
    ),
  );

  Widget _ishaPrayer() => Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        color: getPrayerColor('صلاة العشاء', _controller.prayerTimes),
        borderRadius: BorderRadius.circular(12)
    ),
    child: Row(
      children: [
        SvgPicture.asset('${Const.icons}icon_prayer_current.svg'),
        SizedBox(width: 12),
        Expanded(child: AppText.medium(text: 'صلاة العشاء',fontSize: 15, color: AppColors.colorWhite)),
        AppText.medium(text: _controller.prayer.timings!.isha!,fontSize: 15, color: AppColors.colorWhite)
      ],
    ),
  );


}
 */
