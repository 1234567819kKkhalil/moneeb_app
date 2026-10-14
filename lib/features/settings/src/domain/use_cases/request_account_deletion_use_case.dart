part of settings;

@injectable
class RequestAccountDeletionUseCase {
  final SettingsRepository repository;

  RequestAccountDeletionUseCase(this.repository);

  Future<void> call() {
    return repository.requestAccountDeletion();
  }
}
