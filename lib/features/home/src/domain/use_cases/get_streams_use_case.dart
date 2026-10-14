part of home;

@injectable
class GetStreamsUseCase {
  final HomeRepositories _repository;

  GetStreamsUseCase(this._repository);

  Future<List<StreamModel>> execute() {
    return _repository.getStreams();
  }
}
