part of helpers;

class _BlocRefModel {
  int counter;
  final BlocBase bloc;

  _BlocRefModel({required this.counter, required this.bloc});
}

class BlocScope {
  static final BlocScope instance = BlocScope._();

  BlocScope._();

  final List<_BlocRefModel> _blocs = [];

  BlocBase addBloc<Obj extends BlocBase>() {
    for (int i = 0; i < _blocs.length; i++) {
      if (_blocs[i].bloc.runtimeType.toString() == Obj.toString()) {
        _blocs[i].counter++;
        logDebug("Instance counter incremented: ${_blocs[i].bloc.runtimeType.toString()}");
        return _blocs[i].bloc;
      }
    }

    final newBlocInstance = injector<Obj>();

    _blocs.add(_BlocRefModel(counter: 1, bloc: newBlocInstance));

    logDebug("New Instance Created: ${newBlocInstance.runtimeType.toString()}");
    return newBlocInstance;
  }

  removeBloc(BlocBase bloc) {
    for (int i = 0; i < _blocs.length; i++) {
      if (_blocs[i].bloc.runtimeType.toString() ==
          bloc.runtimeType.toString()) {
        _blocs[i].counter--;

        if (_blocs[i].counter <= 0) {
          _blocs[i].bloc.close();
          logDebug("Instance removed: ${_blocs[i].bloc.runtimeType.toString()}");
          _blocs.removeAt(i);
        } else {
          logDebug("Instance counter decreased: ${_blocs[i].bloc.runtimeType.toString()}");
        }
        return;
      }
    }
  }
}
