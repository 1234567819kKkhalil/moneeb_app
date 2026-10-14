// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../../common/domain/repo/uploads_repo/uploads_repo.dart' as _i795;
import '../../../common/domain/usecases/upload_avatar_usecase.dart' as _i793;
import '../../../common/domain/usecases/upload_certificates_usecase.dart'
    as _i724;
import '../../../common/domain/usecases/upload_identification_usecase.dart'
    as _i22;
import '../../../common/domain/usecases/upload_provider_avatar_usecase.dart'
    as _i449;
import '../../../features/authentication/authentication_imports.dart' as _i919;
import '../../../features/edit_profiles/edit_provider_profile/edit_provider_profile_imports.dart'
    as _i678;
import '../../../features/edit_profiles/edit_user_profile/edit_user_profile_imports.dart'
    as _i247;
import '../../../features/home/home_imports.dart' as _i271;
import '../../../features/my_reviews/my_reviews_imports.dart' as _i320;
import '../../../features/notifications/notifications_imports.dart' as _i295;
import '../../../features/omra_request/omra_request_imports.dart' as _i251;
import '../../../features/omrah/provider/data/repo/omrah_repository_impl.dart'
    as _i185;
import '../../../features/omrah/provider/domain/repo/omrah_repository.dart'
    as _i680;
import '../../../features/omrah/user/data/repo/omrah_inspector_repo.dart'
    as _i472;
import '../../../features/orders/provider_orders/provider_orders_imports.dart'
    as _i296;
import '../../../features/orders/user_orders/user_orders_imports.dart' as _i788;
import '../../../features/provider_profile/provider_profile_imports.dart'
    as _i314;
import '../../../features/settings/settings_imports.dart' as _i581;
import '../../../features/tazkiyah/tazkiyah_imports.dart' as _i818;
import '../../../features/zad/zad_imports.dart' as _i910;
import '../../config/config.dart' as _i658;
import '../../ui/paginated_search_view/paginated_search_view.dart' as _i1041;
import '../../utils/utils_imports.dart' as _i629;
import '../fire_base/fire_base.dart' as _i17;
import '../fire_base/src/fcm_notification/utils/notification_actions_observer/notification_actions_updater.dart'
    as _i802;
import '../localization/localization.dart' as _i268;
import '../media_utils/media_utils.dart' as _i3;
import 'data_injector.dart' as _i518;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i17.GetFcmTokenUseCase>(() => _i17.GetFcmTokenUseCase());
    gh.factory<_i3.ImageCompressionUseCase>(
        () => _i3.ImageCompressionUseCase());
    gh.factory<_i3.VideoCompressUseCase>(() => _i3.VideoCompressUseCase());
    gh.factory<_i3.GetVideoThumbnailUseCase>(
        () => _i3.GetVideoThumbnailUseCase());
    gh.factory<_i295.NotificationsCubit>(() => _i295.NotificationsCubit());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dioConfig);
    gh.lazySingleton<_i973.InternetConnectionChecker>(
        () => registerModule.internetConnectionChecker);
    gh.lazySingleton<_i802.NotificationActionsUpdater>(
        () => _i802.NotificationActionsUpdater());
    gh.lazySingleton<_i3.VideoControllersManager>(
        () => _i3.VideoControllersManager());
    gh.lazySingleton<_i1041.SearchUpdater>(() => _i1041.SearchUpdater());
    gh.lazySingleton<_i629.FocusMonitorUpdater>(
        () => _i629.FocusMonitorUpdater());
    gh.lazySingleton<_i629.OmrahUpdater>(() => _i629.OmrahUpdater());
    gh.lazySingleton<_i314.ProviderProfileRepository>(
        () => _i314.ProviderProfileRepositoryImpl());
    gh.lazySingleton<_i320.MyReviewsRepository>(
        () => _i320.MyReviewsRepositoryImpl());
    gh.factory<_i314.GetProviderProfileUseCase>(() =>
        _i314.GetProviderProfileUseCase(gh<_i314.ProviderProfileRepository>()));
    gh.lazySingleton<_i271.HomeRepositories>(() => _i271.HomeRepositoriesImp());
    gh.lazySingleton<_i629.Encryption>(() => _i629.AESEncryption());
    gh.factory<_i3.AttachmentThumbnailGrabber>(() =>
        _i3.AttachmentThumbnailGrabber(gh<_i3.GetVideoThumbnailUseCase>()));
    gh.singleton<_i919.TokenManager>(
      () => _i919.TokenManager(gh<_i460.SharedPreferences>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i3.AttachmentCompressor>(() => _i3.AttachmentCompressor(
          gh<_i3.ImageCompressionUseCase>(),
          gh<_i3.VideoCompressUseCase>(),
        ));
    gh.factory<_i314.ProviderProfileCubit>(() => _i314.ProviderProfileCubit(
          gh<_i314.GetProviderProfileUseCase>(),
          gh<_i314.ProviderProfileRepository>(),
        ));
    gh.singleton<_i629.NetworkInfo>(
        () => _i629.NetworkInfo(gh<_i973.InternetConnectionChecker>()));
    gh.factory<_i320.GetMyReviewsUseCase>(
        () => _i320.GetMyReviewsUseCase(gh<_i320.MyReviewsRepository>()));
    gh.factory<_i271.GetHomeFeedUseCase>(
        () => _i271.GetHomeFeedUseCase(gh<_i271.HomeRepositories>()));
    gh.factory<_i271.GetStoryProvidersUseCase>(
        () => _i271.GetStoryProvidersUseCase(gh<_i271.HomeRepositories>()));
    gh.factory<_i271.GetProviderStoriesUseCase>(
        () => _i271.GetProviderStoriesUseCase(gh<_i271.HomeRepositories>()));
    gh.factory<_i271.GetBestProvidersUseCase>(
        () => _i271.GetBestProvidersUseCase(gh<_i271.HomeRepositories>()));
    gh.factory<_i271.GetVerifiedProvidersUseCase>(
        () => _i271.GetVerifiedProvidersUseCase(gh<_i271.HomeRepositories>()));
    gh.factory<_i271.GetBannersUseCase>(
        () => _i271.GetBannersUseCase(gh<_i271.HomeRepositories>()));
    gh.factory<_i271.ViewStoryUseCase>(
        () => _i271.ViewStoryUseCase(gh<_i271.HomeRepositories>()));
    gh.factory<_i271.GetStreamsUseCase>(
        () => _i271.GetStreamsUseCase(gh<_i271.HomeRepositories>()));
    gh.lazySingleton<_i658.DioHelper>(() => _i658.DioHelper(
          gh<_i361.Dio>(),
          gh<_i919.TokenManager>(),
        ));
    gh.lazySingleton<_i910.ZadRepository>(
        () => _i910.ZadRepositoryImpl(gh<_i658.DioHelper>()));
    gh.lazySingleton<_i680.OmrahRepository>(
        () => _i185.OmrahRepositoryImpl(gh<_i658.DioHelper>()));
    gh.lazySingleton<_i3.MediaUtilsRepository>(
        () => _i3.MediaUtilsRepositoryImp(gh<_i658.DioHelper>()));
    gh.factory<_i910.AzkarContentCubit>(
        () => _i910.AzkarContentCubit(gh<_i910.ZadRepository>()));
    gh.factory<_i910.TasbeehCubit>(
        () => _i910.TasbeehCubit(gh<_i910.ZadRepository>()));
    gh.factory<_i910.PrayerTimesCubit>(
        () => _i910.PrayerTimesCubit(gh<_i910.ZadRepository>()));
    gh.factory<_i910.EventsCubit>(
        () => _i910.EventsCubit(gh<_i910.ZadRepository>()));
    gh.factory<_i271.StoriesCubit>(() => _i271.StoriesCubit(
          gh<_i271.GetProviderStoriesUseCase>(),
          gh<_i271.ViewStoryUseCase>(),
          gh<_i629.SharedPreferencesHelper>(),
        ));
    gh.lazySingleton<_i818.TazkiyahRepository>(
        () => _i818.TazkiyahRepositoryImpl(gh<_i658.DioHelper>()));
    gh.lazySingleton<_i788.UserOrdersRepository>(
        () => _i788.UserOrdersRepositoryImpl(gh<_i658.DioHelper>()));
    gh.factory<_i818.PostTazkiyahUseCase>(
        () => _i818.PostTazkiyahUseCase(gh<_i818.TazkiyahRepository>()));
    gh.factory<_i818.SearchProviderUseCase>(
        () => _i818.SearchProviderUseCase(gh<_i818.TazkiyahRepository>()));
    gh.factory<_i818.GetMyTazkiyahsUseCase>(
        () => _i818.GetMyTazkiyahsUseCase(gh<_i818.TazkiyahRepository>()));
    gh.lazySingleton<_i581.SettingsRepository>(
        () => _i581.SettingsRepositoryImpl(gh<_i658.DioHelper>()));
    gh.lazySingleton<_i268.LanguageRepo>(
        () => _i268.LanguageRepo(gh<_i658.DioHelper>()));
    gh.lazySingleton<_i472.OmrahInspectorRepo>(
        () => _i472.OmrahInspectorRepo(gh<_i658.DioHelper>()));
    gh.factory<_i581.GetAppSettingsUseCase>(
        () => _i581.GetAppSettingsUseCase(gh<_i581.SettingsRepository>()));
    gh.factory<_i581.GetSocialLinksUseCase>(
        () => _i581.GetSocialLinksUseCase(gh<_i581.SettingsRepository>()));
    gh.factory<_i581.RequestAccountDeletionUseCase>(() =>
        _i581.RequestAccountDeletionUseCase(gh<_i581.SettingsRepository>()));
    gh.factory<_i919.IsAuthenticatedUseCase>(
        () => _i919.IsAuthenticatedUseCase(gh<_i919.TokenManager>()));
    gh.lazySingleton<_i919.AuthRepository>(
        () => _i919.AuthenticationRepositoryImpl(gh<_i658.DioHelper>()));
    gh.lazySingleton<_i247.EditUserProfileRepository>(
        () => _i247.EditUserProfileRepositoryImpl(gh<_i658.DioHelper>()));
    gh.lazySingleton<_i295.NotificationsRepository>(
        () => _i295.NotificationsRepositoryImpl(gh<_i658.DioHelper>()));
    gh.lazySingleton<_i296.ProviderOrdersRepository>(
        () => _i296.ProviderOrdersRepositoryImpl(gh<_i658.DioHelper>()));
    gh.lazySingleton<_i251.OmraRequestRepository>(
        () => _i251.OmraRequestRepositoryImpl(gh<_i658.DioHelper>()));
    gh.factory<_i320.MyReviewsCubit>(
        () => _i320.MyReviewsCubit(gh<_i320.GetMyReviewsUseCase>()));
    gh.factory<_i818.TazkiyahCubit>(() => _i818.TazkiyahCubit(
          gh<_i818.SearchProviderUseCase>(),
          gh<_i818.PostTazkiyahUseCase>(),
          gh<_i818.GetMyTazkiyahsUseCase>(),
        ));
    gh.factory<_i919.DeleteUserAccountUseCase>(
        () => _i919.DeleteUserAccountUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.GetUserDataUseCase>(
        () => _i919.GetUserDataUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.CompleteProviderProfileUseCase>(
        () => _i919.CompleteProviderProfileUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.LogoutUseCase>(
        () => _i919.LogoutUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.ForgotPasswordUseCase>(
        () => _i919.ForgotPasswordUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.VerifyForgotPasswordUseCase>(
        () => _i919.VerifyForgotPasswordUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.ResetPasswordUseCase>(
        () => _i919.ResetPasswordUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.GetOtpConfigUseCase>(
        () => _i919.GetOtpConfigUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.OtpStartUseCase>(
        () => _i919.OtpStartUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.OtpResendUseCase>(
        () => _i919.OtpResendUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i919.SendOTPUseCase>(
        () => _i919.SendOTPUseCase(gh<_i919.AuthRepository>()));
    gh.factory<_i581.SettingsCubit>(() => _i581.SettingsCubit(
          gh<_i581.GetAppSettingsUseCase>(),
          gh<_i581.RequestAccountDeletionUseCase>(),
          gh<_i581.GetSocialLinksUseCase>(),
        ));
    gh.factory<_i919.SetFcmTokenUseCase>(() => _i919.SetFcmTokenUseCase(
          gh<_i919.AuthRepository>(),
          gh<_i17.GetFcmTokenUseCase>(),
        ));
    gh.factory<_i3.UploadFileUseCase>(
        () => _i3.UploadFileUseCase(gh<_i3.MediaUtilsRepository>()));
    gh.lazySingleton<_i678.EditProviderProfileRepository>(
        () => _i678.EditProviderProfileRepositoryImpl(gh<_i658.DioHelper>()));
    gh.factory<_i251.CreateOmraOrderUseCase>(
        () => _i251.CreateOmraOrderUseCase(gh<_i251.OmraRequestRepository>()));
    gh.factory<_i251.GetProvidersUseCase>(
        () => _i251.GetProvidersUseCase(gh<_i251.OmraRequestRepository>()));
    gh.factory<_i919.LoginUseCase>(() => _i919.LoginUseCase(
          gh<_i919.AuthRepository>(),
          gh<_i919.SetFcmTokenUseCase>(),
          gh<_i919.TokenManager>(),
        ));
    gh.factory<_i919.UserRegisterUseCase>(() => _i919.UserRegisterUseCase(
          gh<_i919.AuthRepository>(),
          gh<_i919.SetFcmTokenUseCase>(),
          gh<_i919.TokenManager>(),
        ));
    gh.factory<_i271.HomeCubit>(() => _i271.HomeCubit(
          gh<_i271.GetHomeFeedUseCase>(),
          gh<_i271.GetStoryProvidersUseCase>(),
          gh<_i271.GetBestProvidersUseCase>(),
          gh<_i271.GetVerifiedProvidersUseCase>(),
          gh<_i788.UserOrdersRepository>(),
          gh<_i296.ProviderOrdersRepository>(),
          gh<_i680.OmrahRepository>(),
          gh<_i271.GetBannersUseCase>(),
          gh<_i271.GetStreamsUseCase>(),
          gh<_i629.SharedPreferencesHelper>(),
        ));
    gh.factory<_i3.UploadAttachmentUseCase>(() => _i3.UploadAttachmentUseCase(
          gh<_i3.AttachmentCompressor>(),
          gh<_i3.UploadFileUseCase>(),
          gh<_i3.AttachmentThumbnailGrabber>(),
        ));
    gh.factory<_i919.OtpVerifyUseCase>(() => _i919.OtpVerifyUseCase(
          gh<_i919.AuthRepository>(),
          gh<_i919.SetFcmTokenUseCase>(),
          gh<_i919.TokenManager>(),
        ));
    gh.factory<_i919.OtpRegisterUseCase>(() => _i919.OtpRegisterUseCase(
          gh<_i919.AuthRepository>(),
          gh<_i919.SetFcmTokenUseCase>(),
          gh<_i919.TokenManager>(),
        ));
    gh.lazySingleton<_i251.OmraRequestCubit>(
        () => _i251.OmraRequestCubit(gh<_i251.CreateOmraOrderUseCase>()));
    gh.lazySingleton<_i795.UploadsRepository>(() => _i795.UploadsRepository(
          gh<_i658.DioHelper>(),
          gh<_i3.UploadAttachmentUseCase>(),
        ));
    gh.factory<_i793.UploadAvatarUseCase>(
        () => _i793.UploadAvatarUseCase(gh<_i795.UploadsRepository>()));
    gh.factory<_i724.UploadCertificatesUseCase>(
        () => _i724.UploadCertificatesUseCase(gh<_i795.UploadsRepository>()));
    gh.factory<_i22.UploadIdentificationUseCase>(
        () => _i22.UploadIdentificationUseCase(gh<_i795.UploadsRepository>()));
    gh.factory<_i449.UploadProviderAvatarUseCase>(
        () => _i449.UploadProviderAvatarUseCase(gh<_i795.UploadsRepository>()));
    gh.factory<_i678.EditProviderProfileCubit>(
        () => _i678.EditProviderProfileCubit(
              gh<_i678.EditProviderProfileRepository>(),
              gh<_i449.UploadProviderAvatarUseCase>(),
            ));
    gh.factory<_i247.EditUserProfileCubit>(() => _i247.EditUserProfileCubit(
          gh<_i247.EditUserProfileRepository>(),
          gh<_i793.UploadAvatarUseCase>(),
        ));
    return this;
  }

// initializes the registration of persistent-scope dependencies inside of GetIt
  Future<_i174.GetIt> initPersistentScope(
      {_i174.ScopeDisposeFunc? dispose}) async {
    return _i526.GetItHelper(this).initScopeAsync(
      'persistent',
      dispose: dispose,
      init: (_i526.GetItHelper gh) async {
        final registerModule = _$RegisterModule();
        await gh.factoryAsync<_i460.SharedPreferences>(
          () => registerModule.prefs,
          preResolve: true,
        );
        gh.singleton<_i629.SharedPreferencesHelper>(() =>
            _i629.SharedPreferencesHelperImp(gh<_i460.SharedPreferences>()));
        await gh.singletonAsync<_i268.LocalizationContainer>(
          () {
            final i = _i268.LocalizationContainer(
                gh<_i629.SharedPreferencesHelper>());
            return i.init().then((_) => i);
          },
          preResolve: true,
        );
      },
    );
  }
}

class _$RegisterModule extends _i518.RegisterModule {}
