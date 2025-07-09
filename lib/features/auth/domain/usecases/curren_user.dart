import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/use_case.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';
import '../repository/auth_repository.dart';

class CurrenUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrenUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
