import 'package:blog_app/core/common/cubits/App_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/use_case.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/curren_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrenUser _currenUser;
  final AppUserCubit _appUserCubit;
  AuthBloc(
      {required UserSignUp UserSignUp,
      required UserSignIn userSignIn,
      required CurrenUser currenUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = UserSignUp,
        _userSignIn = userSignIn,
        _currenUser = currenUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthCheckLogin>(_onCheckLogin);
  }
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));
    res.fold(
      (l) => emit(Authfailure(l.message)),
      (user) => _emitAuthSucess(user, emit),
    );
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignIn(UserSignInParams(
      email: event.email,
      password: event.password,
    ));
    res.fold(
      (l) => emit(Authfailure(l.message)),
      (user) => _emitAuthSucess(user, emit),
    );
  }

  void _onCheckLogin(AuthCheckLogin event, Emitter<AuthState> emit) async {
    final res = await _currenUser(NoParams());
    res.fold(
      (l) => emit(Authfailure(l.message)),
      (user) => _emitAuthSucess(user, emit),
    );
  }

  void _emitAuthSucess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
