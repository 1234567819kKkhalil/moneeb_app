part of app_utils;

class OmrahObserver {
  final void Function(String orderId)? omrahCompleted;
  final void Function(OmrahStepperEntity stepper)? omrahStepUpdated;

  OmrahObserver({
    required this.omrahCompleted,
    required this.omrahStepUpdated,
  }) {
    injector<OmrahUpdater>().attachObserver(this);
  }

  void dispose() {
    injector<OmrahUpdater>().deAttachObserver(this);
  }
}
