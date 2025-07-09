import 'package:blog_app/core/common/cubits/App_user/app_user_state.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(user));
    }
  }
}
