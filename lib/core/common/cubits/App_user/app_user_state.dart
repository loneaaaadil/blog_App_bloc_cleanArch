import 'package:blog_app/core/common/entities/user.dart';
import 'package:flutter/material.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;

  AppUserLoggedIn(this.user);
}
