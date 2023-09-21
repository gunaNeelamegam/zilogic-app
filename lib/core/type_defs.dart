import 'package:fpdart/fpdart.dart';
import 'package:zilogic/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
