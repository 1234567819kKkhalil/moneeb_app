part of auth;

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthState> {
  static AuthenticationBloc of(BuildContext context) => BlocProvider.of(context);

  late final TokenManager _tokenManager;
  late final SharedPreferencesHelper _preferencesHelper;
  late final IsAuthenticatedUseCase _isUserAuthenticatedUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final DeleteUserAccountUseCase _deleteUserAccountUseCase;
  late final GetUserDataUseCase _getUserDataUseCase;

  AuthenticationBloc() : super(AuthState.startDecider()) {
    _loadUseCases();

    on<AuthRestartEvent>(_onAuthRestart, transformer: droppable());
    on<AuthRouteChangeEvent>(_onRouteChange, transformer: droppable());
    on<GuestEvent>(_onContinueAsGuest, transformer: droppable());
    on<AuthenticatedEvent>(_onAuthenticated, transformer: droppable());
    on<LoggedOutEvent>(_onLogout, transformer: droppable());
    on<UnAuthorizedEvent>(_onUnAuthorized, transformer: droppable());
    on<DeletedAccountEvent>(_onDelete, transformer: droppable());
    on<FetchUserDataEvent>(_onFetchUserData, transformer: droppable());
    //droppable => Ignore any events added while an event is processing
  }

  void _loadUseCases() {
    _preferencesHelper = injector();
    _isUserAuthenticatedUseCase = injector();
    _logoutUseCase = injector();
    _deleteUserAccountUseCase = injector();
    _getUserDataUseCase = injector();
    _tokenManager = injector();
  }

  //Restart Authentication
  void _onAuthRestart(
    AuthRestartEvent event,
    Emitter<AuthState> emit,
  ) async {
    logDebug('Auth Restarted');

    try {
      await _resetUserDataAndScope();
    } catch (_) {}
    //so if he continued as a guest and went back to get started page, it change the role to the default [User role]
    final currentUserRole =
    getUserRole == UserRoleEnum.guest ? UserRoleEnum.user : getUserRole;

    emit(state.reduce(
        routingState: AuthRouteChangeState(route: event.route),
        userData: StateBox.success(
            AppUserModel.initial(userRole: event.role ?? currentUserRole))));
  }

  void _onRouteChange(
    AuthRouteChangeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.reduce(
      actionState: const AuthActionState.initial(),
      routingState: AuthRouteChangeState(route: event.route),
    ),);
  }

  void _onContinueAsGuest(
    GuestEvent event,
    Emitter<AuthState> emit,
  ) async {
    _preferencesHelper.setGuest();

    emit(state.reduce(
      actionState: const AuthActionState.initial(),
      routingState: AuthRouteChangeState(route: AuthRouteEnum.guest),
      userData: const StateBox.success(AppUserModel.initial(userRole: UserRoleEnum.guest)),
    ));
  }

  //Fill appUserModel with user data then forward the user to MainHostPage
  void _onAuthenticated(
    AuthenticatedEvent event,
    Emitter<AuthState> emit,
  ) async {
    // unsubscribeToGuestTopic();
    _preferencesHelper.deleteGuest();

    logDebug('Auth Authenticated');

    emit(state.reduce(
      actionState: const AuthActionState.initial(),
      routingState: AuthRouteChangeState(route: AuthRouteEnum.authenticated),
      userData: StateBox.success(event.userData),
    ));


    //Add Fcm token refresh listener
    try{
      // refreshFcmSub =
      //     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      //       logDebug("Start update fcm token");
      //       try {
      //         await _updateFcmTokenUseCase.execute(newToken);
      //         logDebug("Update FcmToken: Success $newToken");
      //       } catch (e) {
      //         Logger().f(e);
      //         logDebug("Exception to update fcm token");
      //       }
      //     });
    }catch(e){

    }
  }


  //Reset everything and forward to WelcomePage
  void _onLogout(
    LoggedOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.reduce(
        actionState: const AuthActionState(StateBox.loading(), ActionStateType.logout)
    ));

    await collect(
      task: () async {
        await _logoutUseCase.execute();
        await _resetUserDataAndScope();
        _deleteFcmToken();

        logDebug('Auth Logged out');

        emit(state.reduce(
            actionState: const AuthActionState(StateBox.successWithoutData(), ActionStateType.logout),
            routingState: AuthRouteChangeState(route: AuthRouteEnum.getStartedPage),
            userData: const StateBox.success(AppUserModel.initial())
        ));
      },
      onError: (failure) {
        emit(state.reduce(
          actionState: AuthActionState(StateBox.failure(failure), ActionStateType.logout),
        ));
      },
    );

    emit(state.reduce(actionState: const AuthActionState.initial(),));
  }

  //Reset everything and forward to WelcomePage
  void _onUnAuthorized(
    UnAuthorizedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.reduce(
        actionState: const AuthActionState(StateBox.loading(), ActionStateType.unAuthorized))
    );

    try {
      await _resetUserDataAndScope();
      _deleteFcmToken();
      ProviderTrackingService.instance.dispose();
    } catch (_) {}

    emit(state.reduce(
        actionState: const AuthActionState(StateBox.successWithoutData(), ActionStateType.unAuthorized),
        userData: const StateBox.success(AppUserModel.initial()),
        routingState: AuthRouteChangeState(route: AuthRouteEnum.getStartedPage)
    ));

    emit(state.reduce(actionState: const AuthActionState.initial(),));
  }


  //Delete user account, reset cached data and forward to WelcomePage
  void _onDelete(DeletedAccountEvent event, Emitter<AuthState> emit) async {
    emit(state.reduce(
        actionState: const AuthActionState(StateBox.loading(), ActionStateType.deleteAccount))
    );

    await collect(
      task: () async {
        await _deleteUserAccountUseCase.execute();
        await _resetUserDataAndScope();
        _deleteFcmToken();
        logDebug('Auth Account Deleted');

        emit(state.reduce(
            actionState: const AuthActionState(StateBox.successWithoutData(), ActionStateType.deleteAccount),
            userData: const StateBox.success(AppUserModel.initial()),
            routingState: AuthRouteChangeState(route: AuthRouteEnum.getStartedPage)
        ));
      },
      onError: (failure) {
        emit(state.reduce(
          actionState: AuthActionState(StateBox.failure(failure), ActionStateType.deleteAccount),
        ));
      },
    );

    emit(state.reduce(actionState: const AuthActionState.initial(),));
  }

  void _deleteFcmToken(){
    try{
      FirebaseMessaging.instance.deleteToken();
    } catch(e){}
  }

  Future<void> _resetUserDataAndScope() async {
    _preferencesHelper.resetUserData();
    _tokenManager.deleteTokenFromLocalStorage();

    //Reset DI
    await resetDependenciesScope();

    //close FCM listener
    // refreshFcmSub?.cancel();
    // refreshFcmSub = null;

    //Reset notifications
    Eraser.clearAllAppNotifications();
    Eraser.resetBadgeCountAndRemoveNotificationsFromCenter();
    // LocalNotificationService.initiate().cancelAllNotifications();
  }

  //HELPER METHODS
  bool isUserAuthenticated() {
    return _isUserAuthenticatedUseCase.execute();
  }

  Future<bool> isGuest() async {
    try {
      return _preferencesHelper.isGuest();
    } catch (e) {
      return false;
    }
  }

  void _onFetchUserData(
    FetchUserDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    // iOS: native background tracking may have refreshed the token (while the
    // app was terminated) or hit a 401. Reconcile before fetching user data.
    final shouldLogout = await ProviderTrackingService.instance.syncIosOnStartup();
    if (shouldLogout) {
      add(UnAuthorizedEvent());
      return;
    }

    if(state.routingState.route == AuthRouteEnum.authenticated){
      emit(state.reduce(userData: const StateBox.loading()));
    }

    await collect(
      task: () async {
        AppUserModel userModel = await _getUserDataUseCase.execute();

        if (state.routingState.route == AuthRouteEnum.authenticated) {
          emit(state.reduce(userData: StateBox.success(userModel)));
        } else {
          add(AuthenticatedEvent(userData: userModel));
        }
      },
      onError: (failure) {
        //If user blocked or account deleted and he opened the app, emit UnAuthorizedState
        if (failure is ApiRequestFailure) {
          if (failure.statusCode == StatusCodes.unauthorizedCode ||
              failure.statusCode == StatusCodes.blockedUser) {
            add(UnAuthorizedEvent());
          }
        }
        emit(state.reduce(userData: StateBox.failure(failure)));

        logDebug(failure.errorMessage);
      },
    );
  }

  //Helper Getters
  UserRoleEnum get getUserRole {
    return state.userData.data?.role ?? UserRoleEnum.guest;
  }

  String? get getUserId => state.userData.data?.id;

  AppUserModel get getUserModel {
    return state.userData.data ?? const AppUserModel.initial();
  }

  void _resetAppUserData() {
    emit(state.reduce(userData: const StateBox.initial()));
  }

  //Helper setters
  void setAppUserModel(AppUserModel appUserModel) {
    emit(state.reduce(userData: StateBox.success(appUserModel)));
  }

  void modifyUserModel(AppUserModel Function(AppUserModel userModel) callback) {
    emit(state.reduce(userData: StateBox.success(callback(getUserModel))));
  }

  void startDecider() {
    emit(AuthState.startDecider());
  }
}
