/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneeb/controller/zad/events_controller.dart';
import 'package:moneeb/model/home/feed.dart';
import 'package:moneeb/model/test/occasion_test.dart';
import 'package:moneeb/utils/app_color.dart';
import 'package:moneeb/utils/app_config.dart';
import 'package:moneeb/utils/app_text.dart';
import 'package:moneeb/widget/custom_animation_loading.dart';
import 'package:moneeb/widget/screens/custom_divider.dart';
import 'package:moneeb/widget/screens/zad/occasion_item.dart';

class EventsScreen extends StatelessWidget {
  final _controller = Get.put(EventsController());
  EventsScreen({super.key});

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
              text: 'مناسبات',
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
          child: Column(
            children: [
              AppText.medium(text: 'اليوم', fontSize: 16),
              SizedBox(height: 14),
              CustomDivider(text: 'السبت , 12 يوليو 1443هـ'),
              SizedBox(height: 22),
             FutureBuilder(future: _controller.getFeedData(), builder: (context, snapshot) {
               if(snapshot.connectionState == ConnectionState.done){
                 return  ListView.builder(
                     shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),
                     itemCount: _controller.feed.events!.length,
                     itemBuilder: (_, index) {
                       Events event = _controller.feed.events![index];
                       return EventItem(event: event);
                     });
               }else if(snapshot.connectionState == ConnectionState.waiting){
                 return Center(child: CustomAnimationLoading());
               }else {
                 return SizedBox.shrink();
               }
             }),

            ],
          ),
        ),
      ),
    );
  }
}
 */
