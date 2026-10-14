part of home;

@injectable
class GetBannersUseCase {
  final HomeRepositories _repository;

  GetBannersUseCase(this._repository);

  Future<List<BannerModel>> execute() {
    return _repository.getBanners();
  }
}
