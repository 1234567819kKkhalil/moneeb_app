/* import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneeb/api/api_requestes.dart';
import 'package:moneeb/model/settings/app_settings.dart';
import 'package:moneeb/model/zad/tasbeeh.dart';
import 'package:moneeb/utils/app_color.dart';
import 'package:moneeb/utils/app_config.dart';
import 'package:moneeb/utils/app_text.dart';
import 'package:moneeb/utils/constants.dart';
import 'package:moneeb/widget/custom_button.dart';

class TasbeehScreen extends StatefulWidget {
  @override
  _TasbeehScreenState createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  TextEditingController _zikerController = TextEditingController();
  int count = 0;
  int target = 0;
  String dhikr = 'سبحان الله وبحمده';

  List<TasbeehData> azkhars = [];

  final double size = 240;
  late double progress = 0; // 0%

  // List<AppSettings> azkhars = [
  //   AppSettings(title: 'سبحان الله وبحمده', data: '', isSelected: true),
  //   AppSettings(
  //     title: 'لا اله الا الله وحده لا شريك له',
  //     data: '',
  //     isSelected: false,
  //   ),
  //   AppSettings(title: 'سبحان ربي العظيم', data: '', isSelected: false),
  //   AppSettings(title: 'الحمدلله', data: '', isSelected: false),
  //   AppSettings(title: 'الله اكبر', data: '', isSelected: false),
  //   AppSettings(title: 'سبحان الله', data: '', isSelected: false),
  // ];

  void increment() {
    setState(() {
      if (count < target) {
        count++;
        progress = count / target;
      }
    });
  }

  void reset() {
    setState(() {
      count = 0;
      progress = 0;
    });
    if(_zikerController.text.isNotEmpty) {
      _zikerController.clear();
    }
  }

  void getTasbeeh() async {
    await APIRequestes.fetchTasbeeh()
        .then((data) {
          if(data!.tasbeeh != null || data.tasbeeh!.isNotEmpty){
           setState(() {
             target = data.tasbeeh![0].targetCount!;
             data.tasbeeh![0].isSelected = true;
             azkhars.clear();
             azkhars.addAll(data.tasbeeh!);
           });
          }
    });
  }

  @override
  void initState() {
    super.initState();
    getTasbeeh();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                text: 'مسبحة الإلكتروني',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: increment,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(16),
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
              child: Column(
                children: [
                  Align(
                      alignment: AlignmentDirectional.topStart,
                      child: AppText.medium(text: 'اختار الذكر', fontSize: 16)),
                  SizedBox(height: 18),
                  dhikrButtons(),
                  SizedBox(height: 18),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: dhikrInput()),
                  SizedBox(height: 40),
                  tasbeehCircle(),
                  SizedBox(height: 18),
                  SizedBox(
                    width: 150,
                    child: CustomButton(
                      background: Colors.white,
                      textColor: AppColors.colorAppMain,
                      radius: 14,
                      onPressed: reset,
                      label: 'تصفير المسبحة',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dhikrButtons() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 14,
      childAspectRatio: 2.0,
      children: azkhars.map((tasbeeh) {
        return Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            CustomButton(
              onPressed: () {
                for (TasbeehData data in azkhars) {
                  data.isSelected = false;
                }
                tasbeeh.isSelected = true;
                setState(() {
                  dhikr = tasbeeh.name!.ar ?? '';
                  target = tasbeeh.targetCount!;
                  count = 0;
                  progress = 0;
                });
              },
              padding: 8,
              label: tasbeeh.name!.ar ?? '',
              maxLines: 2,
              textSize: 12,
              textAlign: TextAlign.center,
              borderColor: AppColors.colorAppSub,
            ),
            if (tasbeeh.isSelected)
              SvgPicture.asset(
                '${Const.icons}icon_check1.svg',
                width: 16,
                height: 16,
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget dhikrInput() {
    return TextField(
      controller: _zikerController,
      style: TextStyle(color: AppColors.colorAppMain),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF1F3F6),

        hintText: 'أدخل ذكر ',
        hintStyle: TextStyle(
          fontFamily: Const.appFont,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.colorAppMain,
        ),

        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),

        prefixIcon: SvgPicture.asset(
          '${Const.icons}icon_tasbeeh.svg',
          fit: BoxFit.scaleDown,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: (value) {
        setState(() {
          dhikr = value;
          count = 0;
        });
      },
    );
  }

  Widget tasbeehCircle() {

    final radius = size / 2;
    final angle = (2 * pi * progress) - pi / 2;
    // -pi/2 makes it start from top

    final iconX = radius + radius * cos(angle);
    final iconY = radius + radius * sin(angle);

    return GestureDetector(
      onTap: increment,
      child: SizedBox(
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
                color: AppColors.colorAppMain,
                borderRadius: BorderRadius.circular(150)
              ),
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation(AppColors.colorAppSub),
              ),
            ),

            // Moving icon
            Positioned(
              left: iconX - 8, // half icon size
              top: iconY - 8,
              child: SvgPicture.asset('${Const.icons}icon_tasbeeh_progess.svg'),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: AppText.medium(
                    text: dhikr,
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    maxline: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                AppText.medium(
                  text: "$count",
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),

            Positioned(
              top: -24,
              child: SvgPicture.asset('${Const.icons}icon_time_sala_arrow.svg', height: 20, width: 20,),
            ),


          ],
        ),
      ),
    );
  }
}
 */
