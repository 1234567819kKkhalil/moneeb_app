part of media_utils;

abstract class IVideoViewModel<T>{
  final Attachment attachment;
  final String stackId;
  IVideoViewModel({required this.attachment,required this.playerStateNotifier, required this.stackId, });

  //Listeners count to keep track of number of active listeners so we dispose the controller if there is no active listeners
  int modelUsersCount = 0;

  void increaseListenersCount(){
    modelUsersCount++;
  }

  //to determine if this model has an initialized controller, (necessary when free controllers process starts)
  bool get isHaveInitializedController;

  //State notifier
  final BehaviorSubject<T> playerStateNotifier;
  T get creationState => playerStateNotifier.value;
  void setState(T state) => playerStateNotifier.value = state;

  void pause();
  void play();
  bool get isPlaying;

  bool disposeIfCan({bool forceDispose, bool removeFromStackOnDispose,});
}