/* import 'package:get/get.dart';
import 'package:moneeb/api/api_requestes.dart';
import 'package:moneeb/model/home/feed.dart';
import 'package:moneeb/model/test/occasion_test.dart';
import 'package:moneeb/utils/caching.dart';
import 'package:moneeb/utils/constants.dart';

class EventsController extends GetxController{

  FeedData feed = FeedData();

  List<OccasionTest> occasions = [
    OccasionTest(name: 'شهر رمضان', date: 'يوم الأربعاء 18 فبراير 2026', remain: 'متقبي 12 يومًا', type: 'current'),
    OccasionTest(name: 'ليلة القدر', date: 'يوم الخميس 19 مارس 2026', remain: 'متقبي 39 يوم', type: ''),
    OccasionTest(name: 'المولد النبوي', date: 'يوم الخميس 19 أكتوبر 2026', remain: 'متقبي 9 أشهر', type: ''),
    OccasionTest(name: 'شهر المحرم', date: 'يوم السبت 20 يوتيو 2026', remain: 'متقبي 4 أشهر', type: ''),
    OccasionTest(name: 'عيد الفطر', date: 'يوم الأحد 22 مارس 2026', remain: 'متقبي 43 يوم', type: ''),
    OccasionTest(name: 'عيد الأضحى', date: 'يوم الأربعاء 10 يونيو 2026', remain: 'متقبي 4 أشهر', type: ''),
    OccasionTest(name: 'شهر ذو الحجة', date: 'يوم الإثنين 1 يونيو 2026', remain: 'متقبي 3 أشهر', type: ''),
  ];


  Future<void> getFeedData() async {

    String lat = CacheManager.getLocation(key: Const.KEY_CURRENT_LATITUDE) ?? '21.4225';
    String lng = CacheManager.getLocation(key: Const.KEY_CURRENT_LONGITUDE) ?? '39.8262';

    await APIRequestes.fetchHomeData(lat: lat, lng: lng)
        .then((data) {
      if(data!.data != null){
        feed = data.data!;
        update();
      }
    });
  }

} */
