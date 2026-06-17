import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../repo/profile_repo.dart';

class GetProfileUsecase {
  final ProfileRepo profileRepo;

  GetProfileUsecase({required this.profileRepo});

  Future<Either<Failure, UserEntity>> call() async {
    return await profileRepo.getProfile();
  }
}
