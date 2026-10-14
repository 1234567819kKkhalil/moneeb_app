part of omra_request;

class UmrahPilgrimModel {
  final String id;
  final String name;
  final String username;
  final String? imageUrl;
  final double rating;
  final int completedUmrahs;
  final String location;
  final bool isBest;

  const UmrahPilgrimModel({
    required this.id,
    required this.name,
    required this.username,
    this.imageUrl,
    required this.rating,
    required this.completedUmrahs,
    required this.location,
    this.isBest = false,
  });

  String get fullImageUrl => imageUrl?.addBaseUrl ?? '';
}

class UmrahPilgrimsDummyData {
  static List<UmrahPilgrimModel> get allPilgrims => [
        const UmrahPilgrimModel(
          id: '1',
          name: 'أحمد محمد العتيبي',
          username: 'ahmed_m@',
          rating: 4.8,
          completedUmrahs: 120,
          location: 'مكة المكرمة',
        ),
        const UmrahPilgrimModel(
          id: '2',
          name: 'عبدالله سعد الغامدي',
          username: 'abd_saad@',
          rating: 4.5,
          completedUmrahs: 95,
          location: 'المدينة المنورة',
        ),
        const UmrahPilgrimModel(
          id: '3',
          name: 'خالد عبدالرحمن الشهري',
          username: 'khalid_sh@',
          rating: 4.9,
          completedUmrahs: 200,
          location: 'مكة المكرمة',
        ),
        const UmrahPilgrimModel(
          id: '4',
          name: 'محمد فهد القحطاني',
          username: 'mf_qht@',
          rating: 4.3,
          completedUmrahs: 78,
          location: 'جدة',
        ),
        const UmrahPilgrimModel(
          id: '5',
          name: 'سلطان ناصر الدوسري',
          username: 'sultan_n@',
          rating: 4.7,
          completedUmrahs: 150,
          location: 'مكة المكرمة',
        ),
        const UmrahPilgrimModel(
          id: '6',
          name: 'فهد علي الحربي',
          username: 'fahd_ali@',
          rating: 4.2,
          completedUmrahs: 60,
          location: 'الطائف',
        ),
        const UmrahPilgrimModel(
          id: '7',
          name: 'يوسف إبراهيم المالكي',
          username: 'youssef_m@',
          rating: 4.6,
          completedUmrahs: 110,
          location: 'مكة المكرمة',
        ),
        const UmrahPilgrimModel(
          id: '8',
          name: 'عمر حسن الزهراني',
          username: 'omar_hz@',
          rating: 4.4,
          completedUmrahs: 85,
          location: 'المدينة المنورة',
        ),
      ];

  static List<UmrahPilgrimModel> get bestPilgrims => [
        const UmrahPilgrimModel(
          id: '3',
          name: 'خالد عبدالرحمن الشهري',
          username: 'khalid_sh@',
          rating: 4.9,
          completedUmrahs: 200,
          location: 'مكة المكرمة',
          isBest: true,
        ),
        const UmrahPilgrimModel(
          id: '1',
          name: 'أحمد محمد العتيبي',
          username: 'ahmed_m@',
          rating: 4.8,
          completedUmrahs: 120,
          location: 'مكة المكرمة',
          isBest: true,
        ),
        const UmrahPilgrimModel(
          id: '5',
          name: 'سلطان ناصر الدوسري',
          username: 'sultan_n@',
          rating: 4.7,
          completedUmrahs: 150,
          location: 'مكة المكرمة',
          isBest: true,
        ),
        const UmrahPilgrimModel(
          id: '7',
          name: 'يوسف إبراهيم المالكي',
          username: 'youssef_m@',
          rating: 4.6,
          completedUmrahs: 110,
          location: 'مكة المكرمة',
          isBest: true,
        ),
      ];
}
