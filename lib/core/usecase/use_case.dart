import 'package:fpdart/fpdart.dart';

import '../error/failure.dart';

abstract interface class UseCase<SucessType, Params> {
  Future<Either<Failure, SucessType>> call(Params params);
}

class NoParams {}
