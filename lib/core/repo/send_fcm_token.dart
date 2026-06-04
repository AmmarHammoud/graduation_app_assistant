import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../errors/failures.dart';
import '../services/database_service.dart';
import '../utils/backend_endpoints.dart';

class SendFcmToken {
  final DatabaseService databaseService;

  SendFcmToken({required this.databaseService});
  Future<Either<Failure, void>> sendTokenToServer(String token) async {
    try {
      await databaseService.addData(
        endpoint: BackendEndPoint.sendFCMToken,
        data: {"fcm_token": token},
      );
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}