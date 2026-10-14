part of auth;

enum AuthRouteEnum { deciderPage, getStartedPage, guest, authenticated }

class AuthState extends Equatable {
  final StateBox<AppUserModel> userData;
  final AuthRouteChangeState routingState;
  final AuthActionState actionState;
  const AuthState({
    required this.routingState,
    required this.actionState,
    required this.userData,
  });

  AuthState.startDecider()
    : this(
        userData: const StateBox.initial(),
        actionState: AuthActionState.initial(),
        routingState: AuthRouteChangeState(route: AuthRouteEnum.deciderPage),
      );

  AuthState reduce({
    StateBox<AppUserModel>? userData,
    AuthRouteChangeState? routingState,
    AuthActionState? actionState,
  }) {
    return AuthState(
      userData: userData ?? this.userData,
      routingState: routingState ?? this.routingState,
      actionState: actionState ?? this.actionState,
    );
  }

  @override
  List<Object> get props => [userData, routingState, actionState];
}

// This is responsible for changing pages in BuilderScreen
class AuthRouteChangeState {
  final AuthRouteEnum route;
  final bool disableSwitchAnimation;
  AuthRouteChangeState({
    required this.route,
    this.disableSwitchAnimation = false,
  });
}

// This is responsible for handling actions like logout, delete account ..etc
class AuthActionState extends Equatable {
  final StateBox<void> status;
  final ActionStateType type;
  const AuthActionState(this.status, this.type);

  const AuthActionState.initial()
    : this(const StateBox.initial(), ActionStateType.idle);

  @override
  List<Object?> get props => [status, type];
}

enum ActionStateType { idle, logout, deleteAccount, unAuthorized }
