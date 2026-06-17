import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../repo/profile_repo.dart';

class UpdateProfileUsecase {
  final ProfileRepo profileRepo;

  UpdateProfileUsecase({required this.profileRepo});

  Future<Either<Failure, UserEntity>> call(UserEntity user) async {
    return await profileRepo.updateProfile(user);
  }
}
