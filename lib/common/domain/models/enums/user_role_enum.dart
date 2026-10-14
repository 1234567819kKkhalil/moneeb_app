enum UserRoleEnum {
  user,
  guest,
  provider;

  factory UserRoleEnum.fromApi(String? apiVal){
    switch(apiVal){
      case "REQUESTER":
        return user;
      case "PROVIDER":
        return provider;
      default:
        return user;
    }
  }

  String toApi(){
    switch(this){
      case UserRoleEnum.user:
        return "REQUESTER";
      case UserRoleEnum.provider:
        return "PROVIDER";

      default: return "REQUESTER";
    }
  }

  String toLocalStorage(){
    switch(this){
      case UserRoleEnum.user:
        return "REQUESTER";
      case UserRoleEnum.provider:
        return "PROVIDER";
      case UserRoleEnum.guest:
        return "GUEST";
    }
  }

  factory UserRoleEnum.fromLocalStorage(String val){
    switch(val){
      case "REQUESTER":
        return UserRoleEnum.user;
      case "PROVIDER":
        return UserRoleEnum.provider;
      case "GUEST":
        return UserRoleEnum.guest;

      default:
        return UserRoleEnum.guest;
    }
  }
}