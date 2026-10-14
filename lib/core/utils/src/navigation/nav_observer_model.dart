part of app_utils;

class NavObserverModel<T> extends Equatable{
  final T? currentTab;
  final List<Route> pages;

  const NavObserverModel({this.currentTab, required this.pages});

  NavObserverModel<T> copyWith({
    T? currentTab,
    List<Route>? pages,
  }) {
    return NavObserverModel<T>(
      currentTab: currentTab ?? this.currentTab,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [currentTab,pages];
}