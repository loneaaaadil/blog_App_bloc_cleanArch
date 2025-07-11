import 'package:blog_app/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
}
