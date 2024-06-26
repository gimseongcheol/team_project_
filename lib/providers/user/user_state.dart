import 'package:team_project/models/user_model.dart';

enum UserStatus {
  init,
  submitting,
  success,
}
class UserState{
  final UserStatus userStatus;
  final UserModel userModel;

  const UserState({
    required this.userStatus,
    required this.userModel,
  });
  factory UserState.init(){ //최초의 객체를 생성했을 경우 UserStatus, UserModel 값은 init
    return UserState(userStatus: UserStatus.init, userModel: UserModel.init());
  }

  UserState copyWith({
    UserStatus? userStatus,
    UserModel? userModel,
  }) {
    return UserState(
      userStatus: userStatus ?? this.userStatus,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  String toString() {
    return 'UserState{userStatus: $userStatus, userModel: $userModel}';
  }
}