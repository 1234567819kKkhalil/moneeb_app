class MiqatLocation {
  final String id;
  final String title;
  final double longitude;
  final double latitude;
  const MiqatLocation({
    required this.id,
    required this.title,
    required this.longitude,
    required this.latitude,
  });
}

const List<MiqatLocation> kMiqatLocations = [
  MiqatLocation(
    id: 'dhul_hulaifah',
    title: 'ذو الحليفة',
    longitude: 39.5436,
    latitude: 24.4149,
  ),
  MiqatLocation(
    id: 'al_juhfah',
    title: 'الجحفة',
    longitude: 39.1837,
    latitude: 22.7097,
  ),
  MiqatLocation(
    id: 'qarn_al_manazil',
    title: 'قرن المنازل',
    longitude: 40.415,
    latitude: 21.6312,
  ),
  MiqatLocation(
    id: 'yalamlam',
    title: 'يلملم',
    longitude: 40.0459,
    latitude: 20.7384
  ),
  MiqatLocation(
    id: 'dhat_irq',
    title: 'ذات عرق',
    longitude: 40.3965,
    latitude: 21.9842,
  ),
];
