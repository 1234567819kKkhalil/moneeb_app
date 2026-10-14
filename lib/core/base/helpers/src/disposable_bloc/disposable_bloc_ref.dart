part of helpers;

class DisposableBlocRef {
  final List<BlocBase> _blocs = [];

  BlocBase read<obj extends BlocBase>() {
    for (BlocBase bloc in _blocs) {
      if (bloc.runtimeType.toString() == obj.toString()) {
        return bloc;
      }
    }

    final newInstance = BlocScope.instance.addBloc<obj>();
    _blocs.add(newInstance);

    return newInstance;
  }

  void dispose() {
    for (BlocBase bloc in _blocs) {
      BlocScope.instance.removeBloc(bloc);
    }
  }
}
