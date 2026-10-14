part of auth;

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthRestartEvent extends AuthenticationEvent {
  final AuthRouteEnum route;
  final UserRoleEnum? role;
  final bool disableSwitchAnimation;

  const AuthRestartEvent({
    this.route = AuthRouteEnum.getStartedPage,
    this.role,
    this.disableSwitchAnimation = false,
  });

  @override
  List<Object?> get props => [route, role, disableSwitchAnimation];

//Actions:
// - Reset UserData
// - Set user role to [role] if exists, else it will set the current userRole
// - Forwards to [forwardTo]
}

class AuthRouteChangeEvent extends AuthenticationEvent {
  final AuthRouteEnum route;
  const AuthRouteChangeEvent({required this.route});

  @override
  List<Object?> get props => [route];

//Actions:
// - Forward To GetStartedPage
// - Set userRole [role] if exists
}

class GuestEvent extends AuthenticationEvent {
  //Actions
  //- Forward to MainHostPage
  //- Set userRole to Guest
  //- Save GuestRole in sharedPref so when open the app again, forwards the user to MainHostPage as a guest
  //- Create anonymous session with backend, so i can get a token to can save items in cart ex.
}

class AuthenticatedEvent extends AuthenticationEvent {
  final AppUserModel userData;
  final bool disableSwitchAnimation;

  const AuthenticatedEvent({
    required this.userData,
    this.disableSwitchAnimation = false,
  });

  @override
  List<Object> get props => [userData, disableSwitchAnimation];

//Actions
//- Delete guest from sharedPref
//- Fill appUserModel with user's data coming from graph
//- Cache app user data to the local database
//- Forward the user to MainHostPage
}

class LoggedOutEvent extends AuthenticationEvent {
  //Actions
  //- Perform a logout mutation
  //- Reset App Dependencies
  //- Reset UserData
}

class UnAuthorizedEvent extends AuthenticationEvent {
  //Actions
  //- Reset App Dependencies
  //- Reset UserData
}

class DeletedAccountEvent extends AuthenticationEvent {
  //Actions
  //- Perform a DeleteAccount mutation
  //- Reset App Dependencies
  //- Reset UserData
}

class FetchUserDataEvent extends AuthenticationEvent {}