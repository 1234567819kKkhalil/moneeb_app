part of helpers;

mixin DisposableBlocMixin<T extends StatefulWidget> on State<T> {
  final DisposableBlocRef _disposableBlocRef = DisposableBlocRef();

  obj disposableBloc<obj extends BlocBase>() {
    return _disposableBlocRef.read<obj>() as obj;
  }

  @override
  void dispose() {
    _disposableBlocRef.dispose();
    super.dispose();
  }
}
