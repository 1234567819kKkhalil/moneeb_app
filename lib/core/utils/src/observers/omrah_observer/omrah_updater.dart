part of app_utils;

@lazySingleton
class OmrahUpdater {
  OmrahUpdater();

  final List<OmrahObserver> _observers = [];

  void attachObserver<T>(OmrahObserver observer){
    _observers.add(observer);
  }

  void deAttachObserver(OmrahObserver observer){
    _observers.remove(observer);
  }

  void omrahCompleted(String orderId){
    for(var observer in _observers){
      observer.omrahCompleted?.call(orderId);
    }
  }

  void omrahStepChanged(OmrahStepperEntity stepper){
    for(var observer in _observers){
      observer.omrahStepUpdated?.call(stepper);
    }
  }
}
