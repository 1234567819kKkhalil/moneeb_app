part of auth;

@injectable
class GetUserDataUseCase {
final AuthRepository _repository;
  GetUserDataUseCase(this._repository);
  Future<AppUserModel> execute() async{
    return await _repository.getUserData();
  }
}