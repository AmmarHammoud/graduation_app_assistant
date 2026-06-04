import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, void>> signIn(String email, String password);
  Future<Either<Failure, void>> signUp(
    String name,
    String phoneNumber,
    String email,
    String password,
    String passwordConfirmation,
  );
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> verfyEmail({
    required String code,
    required String email,
  });
  Future<Either<Failure, void>> resendVerficationCode({required String email});
  Future<Either<Failure, void>> resetPassword({
    required String password,
    required String passwordConfirmation,
    required String email,
  });
  Future<Either<Failure, void>> checkCodeResetPassword({
    required String code,
    required String email,
  });
  Future<Either<Failure, void>> forgetPassword({required String email});
}
