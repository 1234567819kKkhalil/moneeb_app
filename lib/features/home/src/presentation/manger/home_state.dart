part of home;

class HomeState extends Equatable {
  final StateBox<FeedData> feedData;
  final StateBox<List<StoryProviderEntity>> storiesData;
  final StateBox<List<ProviderEntity>> bestProviders;
  final StateBox<List<ProviderEntity>> verifiedProviders;
  final List<AppSettings> listVideos;
  final List<UserTest> listLives;
  final List<AppSettings> azkars;
  final List<Stage> listStage;
  final List<UmraTimeLine> timeLines;
  final StateBox<List<OmrahStepperEntity>> activeOmrah;
  final StateBox<List<UpcomingOmrahEntity>> upcomingOmrah;
  final StateBox<List<BannerModel>> banners;
  final StateBox<List<StreamModel>> streams;

  const HomeState({
    this.feedData = const StateBox.initial(),
    this.storiesData = const StateBox.initial(),
    this.bestProviders = const StateBox.initial(),
    this.verifiedProviders = const StateBox.initial(),
    this.listVideos = const [],
    this.listLives = const [],
    this.azkars = const [],
    this.listStage = const [],
    this.timeLines = const [],
    this.activeOmrah = const StateBox.initial(),
    this.upcomingOmrah = const StateBox.initial(),
    this.banners = const StateBox.initial(),
    this.streams = const StateBox.initial(),
  });

  HomeState copyWith({
    StateBox<FeedData>? feedData,
    StateBox<List<StoryProviderEntity>>? storiesData,
    StateBox<List<ProviderEntity>>? bestProviders,
    StateBox<List<ProviderEntity>>? verifiedProviders,
    List<AppSettings>? listVideos,
    List<UserTest>? listLives,
    List<AppSettings>? azkars,
    List<Stage>? listStage,
    List<UmraTimeLine>? timeLines,
    StateBox<List<OmrahStepperEntity>>? activeOmrah,
    StateBox<List<UpcomingOmrahEntity>>? upcomingOmrah,
    StateBox<List<BannerModel>>? banners,
    StateBox<List<StreamModel>>? streams,
  }) {
    return HomeState(
      feedData: feedData ?? this.feedData,
      storiesData: storiesData ?? this.storiesData,
      bestProviders: bestProviders ?? this.bestProviders,
      verifiedProviders: verifiedProviders ?? this.verifiedProviders,
      listVideos: listVideos ?? this.listVideos,
      listLives: listLives ?? this.listLives,
      azkars: azkars ?? this.azkars,
      listStage: listStage ?? this.listStage,
      timeLines: timeLines ?? this.timeLines,
      activeOmrah: activeOmrah ?? this.activeOmrah,
      upcomingOmrah: upcomingOmrah ?? this.upcomingOmrah,
      banners: banners ?? this.banners,
      streams: streams ?? this.streams,
    );
  }

  @override
  List<Object?> get props => [
    feedData,
    storiesData,
    bestProviders,
    verifiedProviders,
    listVideos,
    listLives,
    azkars,
    listStage,
    timeLines,
    activeOmrah,
    upcomingOmrah,
    banners,
    streams,
  ];
}
