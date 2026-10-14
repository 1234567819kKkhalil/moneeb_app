part of app_utils;

mixin OmrahObserverMixin<T extends StatefulWidget> on State<T>{
  OmrahObserver? _observer;

  void initOmrahObserver({
     void Function(String orderId)? omrahCompleted,
     void Function(OmrahStepperEntity stepper)? omrahStepUpdated
  }){
    _observer = OmrahObserver(
      omrahCompleted: omrahCompleted,
      omrahStepUpdated: omrahStepUpdated
    );
  }

  @override
  void dispose() {
    _observer?.dispose();
    _observer = null;
    super.dispose();
  }
}